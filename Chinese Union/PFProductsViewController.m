//
//  PFProductsViewController.m
//  Stripe
//
//  Created by Andrew Wang on 2/26/13.
//

#import "PFProductTableViewCell.h"
#import "PFProductsViewController.h"
#import "PFShippingViewController.h"
#import "CUProducts.h"
#import "UIViewController+Additions.h"
#import "Constants.h"
#import "User.h"
#import "ServiceCallManager.h"
#import "MRProgress.h"


#define ROW_MARGIN 6.0f
#define ROW_HEIGHT 173.0f
#define PICKER_HEIGHT 216.0f
#define SIZE_BUTTON_TAG_OFFSET 1000

@interface PFProductsViewController ()
@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation PFProductsViewController


#pragma mark - Life cycle

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.parseClassName = @"CUProducts";
        [self.tableView registerClass:[PFProductTableViewCell class] forCellReuseIdentifier:@"ParseProduct"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"CU Store", @"");
    
//    UIImage *poweredImage = [UIImage imageNamed:@"Powered.png"];
//    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake((self.tableView.frame.size.width - poweredImage.size.width)/2.0f, 0.0f, self.tableView.frame.size.width, poweredImage.size.height + ROW_MARGIN * 2.0f)];
//    UIButton * poweredButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [poweredButton setImage:poweredImage forState:UIControlStateNormal];
//    [poweredButton addTarget:self action:@selector(openBrowser:) forControlEvents:UIControlEventTouchUpInside];
//    poweredButton.frame = CGRectMake(0.0f, -4.0f, poweredImage.size.width, poweredImage.size.height + 20.0f);
//    [footer addSubview:poweredButton];
//    self.tableView.tableFooterView = footer;

    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, PICKER_HEIGHT)];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.hidden = YES;
    [self.view addSubview:self.pickerView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tableView.contentOffset = CGPointMake(0.0f, 0.0f);
    self.tableView.scrollEnabled = YES;
    self.pickerView.hidden = YES;    
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    
    if (self.shouldAddExitButton) {
        [self addExitButton];
    }
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ParseProduct";
    PFProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[PFProductTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    CUProducts *product = self.objects[indexPath.row];
    [cell configureProduct:product];

    [cell.sizeButton addTarget:self action:@selector(selectSize:) forControlEvents:UIControlEventTouchUpInside];
    cell.sizeButton.tag = SIZE_BUTTON_TAG_OFFSET + indexPath.row;
    
    [cell.orderButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderButton.tag = indexPath.row;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // When any cell is selected, we dismiss the picker view.
    // If you want the cell selection to do some useful work, you can dismiss the picker view in the callback of a gesture recognizer, or implement an accessory control to the picker view that dismisses it.
    [UIView animateWithDuration:0.1f animations:^{
        self.pickerView.frame = CGRectMake(0.0f, self.pickerView.frame.origin.y + PICKER_HEIGHT, tableView.frame.size.width, PICKER_HEIGHT);
    } completion:^(BOOL finished) {
        self.pickerView.hidden = YES;
        // The table view's scrolling is disabled when the picker view is shown. Re-enable it here.
        self.tableView.scrollEnabled = YES;
        
        // Scroll the table to the bottom if the table view's current offset is beyond the maximum
        // allowable offset sot that it does not leave too much white space at the bottom.
        NSInteger numRows = [self tableView:tableView numberOfRowsInSection:0];
        CGFloat maxOffset = numRows * ROW_HEIGHT - self.view.frame.size.height + 36.0f;
        
        if (self.tableView.contentOffset.y > maxOffset) {
            [self.tableView setContentOffset:CGPointMake(0.0f, maxOffset) animated:YES];
        }
    }];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // We show all product names and "Select Size".
    return [PFProducts sizes].count + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return row == 0 ? NSLocalizedString(@"Select Size", @"Select Size") : [PFProducts sizes][row - 1];
}


#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UIButton *sizeButton = (UIButton *)[self.tableView viewWithTag:pickerView.tag + SIZE_BUTTON_TAG_OFFSET];
    NSString *title = [self pickerView:pickerView titleForRow:row forComponent:component];
    [sizeButton setTitle:title forState:UIControlStateNormal];
}


#pragma mark - Event handlers

- (void)next:(UIButton *)button {
    MyLog(@"next UIButton pressed");
    //check if the product is CUMember
    CUProducts *product = self.objects[button.tag];
    if([product.objectId isEqualToString:CUMemberObjectID])
    {
        MyLog(@"This product is CU Member! check if the user is a member already");
        [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Checking" mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
        User *user = [ServiceCallManager getCurrentUser];
        if(user.cuMember != nil)
        {
            MyLog(@"This user is already a member! Purchasing request rejected");
            [self showAlertTitle:@"Error" msg:@"You are already a member, please don't purchase again"];
            return;
        }
        
        
    }
    UIButton *sizeButton = (UIButton *)[self.tableView viewWithTag:(button.tag + SIZE_BUTTON_TAG_OFFSET)];
    NSString *size = sizeButton ? [sizeButton titleForState:UIControlStateNormal] : nil;
    
    if (self.objects[button.tag][@"hasSize"] && [size isEqualToString:NSLocalizedString(@"Select Size", @"Select Size")]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Size", @"Missing Size") message:NSLocalizedString(@"Please select a size.", @"Please select a size.") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        [alertView show];
    } else {
        PFShippingViewController *shippingController = [[PFShippingViewController alloc] initWithProduct:self.objects[button.tag] size:size];
        [self.navigationController pushViewController:shippingController animated:YES];        
    }
}

- (void)selectSize:(id)sender {
    // This method shows the picker view for size selection.
    NSInteger row = ((UIButton *)sender).tag - SIZE_BUTTON_TAG_OFFSET;
    
    // Scroll to the row so that the picker view does not conceal any input.
    CGFloat offset = (row + 1) * ROW_HEIGHT - self.view.frame.size.height + PICKER_HEIGHT;
    if (offset < 0.0f) {
        offset = 0.0f;
    }
    
    [self.tableView setContentOffset:CGPointMake(0.0f, offset) animated:YES];
    
    // Disable scrolling in the table view so that user stays focused on the picker view.
    self.tableView.scrollEnabled = NO;
    
    // Assign the tag to the picker so that the picker knows which product's size it is selecting.
    self.pickerView.tag = row;

    self.pickerView.hidden = NO;
    
    // Default for picker view's initial selection.
    [self.pickerView selectRow:0 inComponent:0 animated:NO];

    self.pickerView.frame = CGRectMake(0.0f, offset + self.view.frame.size.height, self.tableView.frame.size.width, PICKER_HEIGHT);
    [UIView animateWithDuration:0.1f animations:^{
        self.pickerView.frame = CGRectMake(0.0f, offset + self.view.frame.size.height - PICKER_HEIGHT, self.tableView.frame.size.width, PICKER_HEIGHT);
    }];
}

- (void)openBrowser:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.parse.com/store"]];
}

- (void)showAlertTitle:(NSString *)title msg:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
}


@end
