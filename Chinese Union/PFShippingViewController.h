//
//  PFShippingViewController.h
//  Store
//
//  Created by Andrew Wang on 2/26/13.
//

@interface PFShippingViewController : UITableViewController <UITextFieldDelegate>
- (id)initWithProduct:(PFObject *)product size:(NSString *)size;
@property (nonatomic) BOOL shouldAddExitButton;

@end
