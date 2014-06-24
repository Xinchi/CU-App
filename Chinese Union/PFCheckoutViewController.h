//
//  PFCheckoutViewController.h
//  Store
//
//  Created by Andrew Wang on 2/28/13.
//

#import "STPCheckoutView.h"

@interface PFCheckoutViewController : UIViewController <STPCheckoutDelegate>
- (id)initWithProduct:(PFObject *)product size:(NSString *)size shippingInfo:(NSDictionary *)otherShippingInfo;
@end
