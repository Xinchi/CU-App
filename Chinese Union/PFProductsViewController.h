//
//  PFProductsViewController.h
//  Stripe
//
//  Created by Andrew Wang on 2/26/13.
//

@interface PFProductsViewController : PFQueryTableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

- (id)initWithStyle:(UITableViewStyle)style;

@property (nonatomic) BOOL shouldAddExitButton;

@end