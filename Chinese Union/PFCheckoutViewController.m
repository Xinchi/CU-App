//
//  PFCheckoutViewController.m
//  Store
//
//  Created by Andrew Wang on 2/28/13.
//

#import "MBProgressHUD.h"
#import "PFCheckoutViewController.h"
#import "PFFinishViewController.h"

@interface PFCheckoutViewController ()

@property (nonatomic) PFObject *product;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, strong) NSDictionary *shippingInfo;
@property (nonatomic, strong) STPCheckoutView *checkoutView;
@property (nonatomic, strong) MBProgressHUD *hud;

- (void)displayError:(NSError *)error;
- (void)charge:(STPToken *)token;
@end

@implementation PFCheckoutViewController


#pragma mark - Life cycle

- (id)initWithProduct:(PFObject *)product size:(NSString *)otherSize shippingInfo:(NSDictionary *)otherShippingInfo {
    if (self = [super init]) {
        self.product = product;
        self.size = otherSize;
        self.shippingInfo = otherShippingInfo;
    }
    return self;
}


#pragma mark - UIViewController

- (void)loadView {
    [super loadView];

    UIImage *backgroundStripe = [UIImage imageNamed:@"TopBarBg.png"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, backgroundStripe.size.height)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:backgroundStripe];
    [self.view addSubview:headerView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backButtonImage = [UIImage imageNamed:@"ButtonBack.png"];
    UIImage *backButtonPressedImage = [UIImage imageNamed:@"ButtonBackPressed.png"];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    [backButton setImage:backButtonPressedImage forState:UIControlStateHighlighted];
    backButton.frame = CGRectMake(-10.0f, -10.0f, backButtonImage.size.width + 30.0f, backButtonImage.size.height + 30.0f);
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"Checkout", @"Checkout");
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f];
    titleLabel.textColor = [UIColor colorWithRed:132.0f/255.0f green:140.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    titleLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7];
    titleLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((self.view.frame.size.width - titleLabel.frame.size.width)/2.0f, (backgroundStripe.size.height - titleLabel.frame.size.height)/2.0f, titleLabel.frame.size.width, titleLabel.frame.size.height);    
    [self.view addSubview:titleLabel];

    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setTitle:NSLocalizedString(@"Buy", @"Buy") forState:UIControlStateNormal];
    buyButton.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    buyButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -0.5f);
    buyButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
    
    UIImage *orderImage = [UIImage imageNamed:@"ButtonOrder.png"];
    UIImage *orderPressedImage = [UIImage imageNamed:@"ButtonOrderPressed.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(orderImage.size.height/2, orderImage.size.width/2, orderImage.size.height/2, orderImage.size.width/2);
    [buyButton setBackgroundImage:[orderImage resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
    [buyButton setBackgroundImage:[orderPressedImage resizableImageWithCapInsets:insets] forState:UIControlStateHighlighted];
    buyButton.frame = CGRectMake(self.view.frame.size.width - 52.0f - 5.0f, 5.0f, 52.0f, orderImage.size.height);
    [buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyButton];
    
    UIImage *creditCardImage = [UIImage imageNamed:@"CreditCardBg.png"];
    UIImageView *creditCardView = [[UIImageView alloc] initWithImage:creditCardImage];
    creditCardView.frame = CGRectMake((self.view.frame.size.width - creditCardImage.size.width)/2.0f, 90.0f, creditCardImage.size.width, creditCardImage.size.height);
    [self.view addSubview:creditCardView];
    
    UILabel *creditCardLabel = [[UILabel alloc] init];
    creditCardLabel.text = NSLocalizedString(@"Enter your credit card information", @"Enter your credit card information");
    creditCardLabel.backgroundColor = [UIColor clearColor];
    creditCardLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f];
    creditCardLabel.textColor = [UIColor colorWithRed:72.0f/255.0f green:98.0f/255.0f blue:111.0f/255.0f alpha:1.0f];
    creditCardLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7];
    creditCardLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    [creditCardLabel sizeToFit];
    creditCardLabel.frame = CGRectMake(25.0f, 115.0f, creditCardLabel.frame.size.width, creditCardLabel.frame.size.height);
    [self.view addSubview:creditCardLabel];
    
    self.checkoutView = [[STPCheckoutView alloc] initWithFrame:CGRectMake(15.0f, 165.0f, 290.0f, 55.0f) andKey:[[NSBundle mainBundle] infoDictionary][@"STRIPE_PUBLISHABLE_KEY"]];
    self.checkoutView.delegate = self;
    [self.view addSubview:self.checkoutView];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
}


#pragma mark - Event handlers

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buy:(id)sender {
    self.hud.labelText = NSLocalizedString(@"Authorizing...", @"Authorizing...");
    [self.hud show:YES];
    
    [self.checkoutView createToken:^(STPToken *token, NSError *error) {
        if (error) {
            [self.hud hide:YES];
            [self displayError:error];
        } else {
            [self charge:token];
        }
    }];
}


#pragma mark - ()

- (void)displayError:(NSError *)error {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)charge:(STPToken *)token {
    self.hud.labelText = @"Charging...";
    
    NSDictionary *productInfo = @{
                                  @"itemName": self.product[@"name"],
                                  @"size": self.size ?: @"N/A",
                                  @"cardToken": token.tokenId,
                                  @"name": self.shippingInfo[@"name"],
                                  @"email": self.shippingInfo[@"email"],
                                  @"address": self.shippingInfo[@"address"],
                                  @"zip": self.shippingInfo[@"zip"],
                                  @"city_state": self.shippingInfo[@"cityState"]
                                };
    [PFCloud callFunctionInBackground:@"purchaseItem"
                       withParameters:productInfo
                                block:^(id object, NSError *error) {
                                    [self.hud hide:YES];                                    
                                    if (error) {
                                        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                                    message:[[error userInfo] objectForKey:@"error"]
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                          otherButtonTitles:nil] show];
                                        
                                    } else {
                                        PFFinishViewController *finishController = [[PFFinishViewController alloc] initWithProduct:self.product];
                                        [self.navigationController pushViewController:finishController animated:YES];
                                    }
                                }];
}

@end
