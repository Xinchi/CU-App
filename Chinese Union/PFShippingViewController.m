//
//  PFShippingViewController.m
//  Store
//
//  Created by Andrew Wang on 2/26/13.
//

#import "PFProducts.h"
#import "PFCheckoutViewController.h"
#import "PFShippingViewController.h"
#import "ServiceCallManager.h"
#import "MRProgress.h"
#import "OverlayManager.h"

#define TEXT_FIELD_TAG_OFFSET 1000
#define NUM_TEXT_FIELD 5

typedef enum {
    PFShippingSectionName,
    PFShippingSectionEmail,
    PFShippingSectionAddress
} PFShippingSection;

typedef enum {
    PFAddressRowAddress,
    PFAddressRowCityState,
    PFAddressRowZipCode
} PFAddressRow;

@interface PFShippingViewController ()
@property (nonatomic, strong) PFObject *product;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *addressField;
@property (nonatomic, strong) UITextField *cityStateField;
@property (nonatomic, strong) UITextField *postalCodeField;

- (void)addHeaderView;
- (void)addFooterView;
- (void)addTextFields;
- (void)scrollViewToScreenTop:(UITextField *)textField;
- (void)dismissKeyboard;
- (BOOL)isEmailValid:(NSString *)email;
- (BOOL)isValid;
@end

@implementation PFShippingViewController


#pragma mark - Life cycle

- (id)initWithProduct:(PFObject *)product size:(NSString *)size {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.product = product;
        self.size = size;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Shipping"];
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = [UIColor colorWithRed:249.0f/255.0 green:252.0f/255.0f blue:253.0f/255.0f alpha:1.0f];
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addHeaderView];
    [self addFooterView];
    [self addTextFields];
    
    // Any tap on the view would dismiss the keyboard.
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    //check if the product is CUMember
    
    if([self.product.objectId isEqualToString:CUMemberObjectID])
    {
        [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Checking" mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];

        [ServiceCallManager checkIfTheUserIsAMemberWithBlock:^(BOOL isAMember, NSError *error) {
            if(isAMember)
            {
                MyLog(@"This user is already a member! Purchasing request rejected");
                [OverlayManager showAlertTitle:@"Ohhh" msg:@"You are already a member, and you don't want to purchase this again : )" onView:self.view];
            }
            else {
                [OverlayManager dismissAllOverlayViewForView:self.view];
            }
        }];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger result;
    switch (section) {
        case 0:
            result = 1;
            break;
        case 1:
            result = 1;
            break;
        default:
            result = 3;
            break;
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Shipping";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == PFShippingSectionName) {
        [cell.contentView addSubview:self.nameField];
    } else if (indexPath.section == PFShippingSectionEmail) {
        [cell.contentView addSubview:self.emailField];
    } else if (indexPath.section == PFShippingSectionAddress) {
        if (indexPath.row == PFAddressRowAddress) {
            [cell.contentView addSubview:self.addressField];
        } else if (indexPath.row == PFAddressRowCityState) {
            [cell.contentView addSubview:self.cityStateField];
        } else if (indexPath.row == PFAddressRowZipCode) {
            [cell.contentView addSubview:self.postalCodeField];            
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return [[UIScreen mainScreen] bounds].size.height > 480.0f ? 9.0f : 3.0f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // Scroll the table so that the field becomes visible.
    [self scrollViewToScreenTop:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == TEXT_FIELD_TAG_OFFSET + NUM_TEXT_FIELD - 1) {
        // Dismiss the keyboard if it's the last field.
        [self dismissKeyboard];
        
        // Go to checkout.
        [self next:nil];
    } else {
        // Let the next text field gain focus.
        [[self.tableView viewWithTag:textField.tag + 1] becomeFirstResponder];
    }
    return YES;
}


#pragma mark - Event handlers

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)next:(id)sender {
    if ([self isValid]) {
        NSDictionary *shippingInfo = @{@"name": self.nameField.text ?: @"",
                                       @"email": self.emailField.text ?: @"",
                                       @"address": self.addressField.text ?: @"",
                                       @"zip": self.postalCodeField.text ?: @"",
                                       @"cityState": self.cityStateField.text ?: @"" };
        UIViewController *checkoutController = [[PFCheckoutViewController alloc] initWithProduct:self.product size:self.size shippingInfo:shippingInfo];
        [self.navigationController pushViewController:checkoutController animated:YES];
    }
}

- (void)openBrowser:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.parse.com/store"]];
}


#pragma mark - ()

- (void)addHeaderView {
    UIImage *backgroundStripe = [UIImage imageNamed:@"ShippingHeader.png"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, backgroundStripe.size.height)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:backgroundStripe];
    self.tableView.tableHeaderView = headerView;
    
    CGFloat x = -10.0f;
    CGFloat y;
    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *backButtonImage = [UIImage imageNamed:@"ButtonBack"];
//    UIImage *backButtonPressedImage = [UIImage imageNamed:@"ButtonBackPressed"];
//    [backButton setImage:backButtonImage forState:UIControlStateNormal];
//    [backButton setImage:backButtonPressedImage forState:UIControlStateHighlighted];
//    backButton.frame = CGRectMake(x, x, backButtonImage.size.width + 30.0f, backButtonImage.size.height + 30.0f);
//    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:backButton];
//    x += backButtonImage.size.width + 15.0f;
    
    PFImageView *productImageView = [[PFImageView alloc] init];
    productImageView.file = self.product[@"image"];
    productImageView.contentMode = UIViewContentModeScaleAspectFit;
    productImageView.frame = CGRectMake(x, 0.0f, 120.0f - 40.0f, 94.0f);
    productImageView.clipsToBounds = YES;
    [headerView addSubview:productImageView];
    x += productImageView.frame.size.width + 5.0f;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    priceLabel.text = [NSString stringWithFormat:@"$%d",[self.product[@"price"] intValue]];
    priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f];
    priceLabel.textColor = [UIColor colorWithRed:14.0f/255.0f green:190.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    priceLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    priceLabel.shadowOffset = CGSizeMake(0, 0.5f);
    priceLabel.backgroundColor = [UIColor clearColor];
    [priceLabel sizeToFit];
    CGFloat priceX = self.view.frame.size.width - priceLabel.frame.size.width - 10.0f;
    priceLabel.frame = CGRectMake(priceX, 10.0f, priceLabel.frame.size.width, priceLabel.frame.size.height);
    [self.view addSubview:priceLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.text = self.product[@"description"];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f];
    nameLabel.textColor = [UIColor colorWithRed:82.0f/255.0f green:87.0f/255.0f blue:90.0f/255.0f alpha:1.0f];
    nameLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    nameLabel.shadowOffset = CGSizeMake(0, 0.5f);
    nameLabel.backgroundColor = [UIColor clearColor];
    [nameLabel sizeToFit];
    y = 30.0f;
    nameLabel.frame = CGRectMake(x, y, nameLabel.frame.size.width, nameLabel.frame.size.height);
    [self.view addSubview:nameLabel];
    y += nameLabel.frame.size.height;
    
    UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    sizeLabel.text = self.size;
    sizeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f];
    sizeLabel.textColor = [UIColor colorWithRed:138.0f/255.0f green:144.0f/255.0f blue:148.0f/255.0f alpha:1.0f];
    sizeLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    sizeLabel.shadowOffset = CGSizeMake(0, 0.5f);
    sizeLabel.backgroundColor = [UIColor clearColor];
    [sizeLabel sizeToFit];
    sizeLabel.frame = CGRectMake(x, y, sizeLabel.frame.size.width, sizeLabel.frame.size.height);
    [self.view addSubview:sizeLabel];
    y += sizeLabel.frame.size.height + 2.0f;
    
    UILabel *shippingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    shippingLabel.text = NSLocalizedString(@"Shipping Information", @"Shipping Information");
    shippingLabel.backgroundColor = [UIColor clearColor];
    shippingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f];
    shippingLabel.textColor = [UIColor colorWithRed:132.0f/255.0f green:140.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    shippingLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    shippingLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [shippingLabel sizeToFit];
    shippingLabel.frame = CGRectMake((self.tableView.frame.size.width - shippingLabel.frame.size.width)/2.0f, headerView.frame.size.height - shippingLabel.frame.size.height - 13.0f, shippingLabel.frame.size.width, shippingLabel.frame.size.height);
    [headerView addSubview:shippingLabel];
}

- (void)addFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 130.0f)];
    
    UILabel *usOnlyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    usOnlyLabel.text = NSLocalizedString(@"US mailing address only", @"US mailing address only");
    usOnlyLabel.backgroundColor = [UIColor clearColor];
    usOnlyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0f];
    usOnlyLabel.textColor = [UIColor colorWithRed:132.0f/255.0f green:140.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    usOnlyLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    usOnlyLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [usOnlyLabel sizeToFit];
    usOnlyLabel.frame = CGRectMake((self.tableView.frame.size.width - usOnlyLabel.frame.size.width)/2.0f, 2.0f, usOnlyLabel.frame.size.width, usOnlyLabel.frame.size.height);
    [footer addSubview:usOnlyLabel];
    
    UIButton *checkoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkoutButton setTitle:NSLocalizedString(@"Checkout", @"Checkout") forState:UIControlStateNormal];
    checkoutButton.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    checkoutButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -0.5f);
    
    UIImage *checkoutImage = [UIImage imageNamed:@"ButtonCheckout.png"];
    UIImage *checkoutPressedImage = [UIImage imageNamed:@"ButtonCheckoutPressed.png"];
    UIImage *checkoutIcon = [UIImage imageNamed:@"IconCheckout.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(checkoutImage.size.height/2, checkoutImage.size.width/2, checkoutImage.size.height/2, checkoutImage.size.width/2);
    [checkoutButton setBackgroundImage:[checkoutImage resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
    [checkoutButton setBackgroundImage:[checkoutPressedImage resizableImageWithCapInsets:insets] forState:UIControlStateHighlighted];
    [checkoutButton setImage:checkoutIcon forState:UIControlStateNormal];
    [checkoutButton setImage:checkoutIcon forState:UIControlStateHighlighted];
    [checkoutButton setImageEdgeInsets:UIEdgeInsetsMake(0.0f, -50.0f, 0.0f, 0.0f)];
    [checkoutButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, -checkoutIcon.size.width, 0.0f, 0.0f)];
    [checkoutButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat y = [[UIScreen mainScreen] bounds].size.height > 480.0f ? 30.0f : 18.0f;
    checkoutButton.frame = CGRectMake((self.tableView.frame.size.width - 195.0)/2.0f, y, 195.0f, checkoutImage.size.height);
    [footer addSubview:checkoutButton];
    
//    UIImage *poweredImage = [UIImage imageNamed:@"Powered.png"];
//    UIButton * poweredButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [poweredButton setImage:poweredImage forState:UIControlStateNormal];
//    [poweredButton addTarget:self action:@selector(openBrowser:) forControlEvents:UIControlEventTouchUpInside];
//    poweredButton.frame = CGRectMake((self.tableView.frame.size.width - poweredImage.size.width)/2.0f, footer.frame.size.height - 20.0f - poweredImage.size.height, poweredImage.size.width, poweredImage.size.height + 20.0f);
//    [footer addSubview:poweredButton];
//    
    self.tableView.tableFooterView = footer;
}

- (void)addTextFields {
    // The only tricky thing this methods does is thatit assigns the text field's tag in sequential order.
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(8.0f, 10.0f, self.tableView.frame.size.width - 20.0f, 44.0f)];
    self.nameField.delegate = self;
    self.nameField.placeholder = NSLocalizedString(@"Name", @"Name");
    self.nameField.returnKeyType = UIReturnKeyNext;
    self.nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.nameField.tag = TEXT_FIELD_TAG_OFFSET;
    
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(8.0f, 10.0f, self.tableView.frame.size.width - 20.0f, 44.0f)];
    self.emailField.delegate = self;
    self.emailField.placeholder = NSLocalizedString(@"Email", @"Email");
    self.emailField.returnKeyType = UIReturnKeyNext;
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.tag = TEXT_FIELD_TAG_OFFSET + 1;
    
    self.addressField = [[UITextField alloc] initWithFrame:CGRectMake(8.0f, 10.0f, self.tableView.frame.size.width - 20.0f, 44.0f)];
    self.addressField.delegate = self;
    self.addressField.placeholder = NSLocalizedString(@"Address", @"Address");
    self.addressField.returnKeyType = UIReturnKeyNext;
    self.addressField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.addressField.tag = TEXT_FIELD_TAG_OFFSET + 2;
    
    self.cityStateField = [[UITextField alloc] initWithFrame:CGRectMake(8.0f, 10.0f, self.tableView.frame.size.width - 20.0f, 44.0f)];
    self.cityStateField.delegate = self;
    self.cityStateField.placeholder = NSLocalizedString(@"City, State", @"City, State");
    self.cityStateField.returnKeyType = UIReturnKeyDone;
    self.cityStateField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.cityStateField.tag = TEXT_FIELD_TAG_OFFSET + 3;
    
    self.postalCodeField = [[UITextField alloc] initWithFrame:CGRectMake(8.0f, 10.0f, self.tableView.frame.size.width - 20.0f, 44.0f)];
    self.postalCodeField.delegate = self;
    self.postalCodeField.placeholder = NSLocalizedString(@"Postal Code", @"Postal Code");
    self.postalCodeField.returnKeyType = UIReturnKeyNext;
    self.postalCodeField.keyboardType = UIKeyboardTypeNumberPad;
    self.postalCodeField.tag = TEXT_FIELD_TAG_OFFSET + 4;
}

- (void)scrollViewToScreenTop:(UITextField *)textField {
    // The super view of a text field is the contentView of a cell.
    // The super vie of the contentView is the cell itself.
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)dismissKeyboard {
    // To dismiss the keyboard, we simply ask all fields to resign its focus.
    for (int i = TEXT_FIELD_TAG_OFFSET; i < TEXT_FIELD_TAG_OFFSET + NUM_TEXT_FIELD; i++) {
        [[self.view viewWithTag:i] resignFirstResponder];
    }
}

- (BOOL)isEmailValid:(NSString *)email {
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
    return [regex evaluateWithObject:email];
}

- (BOOL)isValid {
    for (int i = 0; i < NUM_TEXT_FIELD; i++) {
        UITextField *field = (UITextField *)[self.view viewWithTag:TEXT_FIELD_TAG_OFFSET + i];
        if (!field.text) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Field", @"Missing Field") message:NSLocalizedString(@"Please fill in all fields.", @"Please fill in all fields.") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil] show];
            return NO;
        }
    }
    
    if (![self isEmailValid:self.emailField.text]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Email", @"Invalid Email") message:NSLocalizedString(@"Please enter a valid email.", @"Please enter a valid email.") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil] show];
        [self.emailField becomeFirstResponder];
        return NO;
    }
    return YES;
}

@end
