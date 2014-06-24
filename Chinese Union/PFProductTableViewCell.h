//
//  PFProductTableViewCell.h
//  Store
//
//  Created by Andrew Wang on 3/5/13.
//

@interface PFProductTableViewCell : PFTableViewCell

@property (nonatomic, strong) UIButton *sizeButton;
@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, strong) UILabel *priceLabel;

- (void)configureProduct:(PFObject *)product;

@end
