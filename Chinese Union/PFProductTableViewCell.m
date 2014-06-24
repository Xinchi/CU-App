//
//  PFProductTableViewCell.m
//  Store
//
//  Created by Andrew Wang on 3/5/13.
//

#import "PFProductTableViewCell.h"
#import "CUProducts.h"

#define ROW_MARGIN 6.0f
#define ROW_HEIGHT 173.0f

@implementation PFProductTableViewCell

#pragma mark - Life cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f];
        self.priceLabel.textColor = [UIColor colorWithRed:14.0f/255.0f green:190.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        self.priceLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
        self.priceLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
        self.priceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.priceLabel];
        
        self.orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.orderButton setTitle:NSLocalizedString(@"Order", @"Order") forState:UIControlStateNormal];
        self.orderButton.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        self.orderButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -0.5f);
        self.orderButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
        
        UIImage *orderImage = [UIImage imageNamed:@"ButtonOrder.png"];
        UIImage *orderPressedImage = [UIImage imageNamed:@"ButtonOrderPressed.png"];
        UIEdgeInsets insets = UIEdgeInsetsMake(orderImage.size.height/2, orderImage.size.width/2, orderImage.size.height/2, orderImage.size.width/2);
        [self.orderButton setBackgroundImage:[orderImage resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
        [self.orderButton setBackgroundImage:[orderPressedImage resizableImageWithCapInsets:insets] forState:UIControlStateHighlighted];
        [self addSubview:self.orderButton];
    }
    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    CGFloat x = ROW_MARGIN;
    CGFloat y = ROW_MARGIN;
    self.backgroundView.frame = CGRectMake(x, y, self.frame.size.width - ROW_MARGIN*2.0f, 167.0f);
    x += 10.0f;

    self.imageView.frame = CGRectMake(x, y + 1.0f, 120.0f, 165.0f);
    x += 120.0f + 5.0f;
    y += 10.0f;
    
    [self.priceLabel sizeToFit];
    CGFloat priceX = self.frame.size.width - self.priceLabel.frame.size.width - ROW_MARGIN - 10.0f;
    self.priceLabel.frame = CGRectMake(priceX, ROW_MARGIN + 10.0f, self.priceLabel.frame.size.width, self.priceLabel.frame.size.height);
    
    y = self.sizeButton ? 45.0f : 55.0f;
    
    [self.textLabel sizeToFit];
    self.textLabel.frame = CGRectMake(x + 2.0f, y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    y += self.textLabel.frame.size.height + 2.0f;
    
    if (self.sizeButton) {
        self.sizeButton.frame = CGRectMake(x, y, 157.0f, 40.0f);
        y += self.sizeButton.frame.size.height + 5.0f;
    } else {
        y += 6.0f;
    }
    
    self.orderButton.frame = CGRectMake(x, y, 80.0f, 35.0f);
}


#pragma mark - UITableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.sizeButton removeFromSuperview];
}


#pragma mark - Public

- (void)configureProduct:(CUProducts *)product {
    UIImage *backgroundImage = [UIImage imageNamed:@"Product.png"];
    UIEdgeInsets backgroundInsets = UIEdgeInsetsMake(backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f, backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f);
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[backgroundImage resizableImageWithCapInsets:backgroundInsets]];
    self.backgroundView = backgroundImageView;
    
    self.imageView.file = (PFFile *)product[@"image"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView loadInBackground];
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%d", [product[@"price"] intValue]];

    self.textLabel.text = product[@"description"];
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19.0f];
    self.textLabel.textColor = [UIColor colorWithRed:82.0f/255.0f green:87.0f/255.0f blue:90.0f/255.0f alpha:1.0f];
    self.textLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    self.textLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    if ([product[@"hasSize"] boolValue]) {
        self.sizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sizeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.sizeButton setTitle:NSLocalizedString(@"Select Size", @"Select Size") forState:UIControlStateNormal];
        [self.sizeButton setTitleColor:[UIColor colorWithRed:95.0f/255.0f green:95.0f/255.0f blue:95.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [self.sizeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 16.0f, 0.0f, 0.0f)];
        self.sizeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
        [self.sizeButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sizeButton.titleLabel.textColor = [UIColor colorWithRed:95.0f/255.0f green:95.0f/255.0f blue:90.0f/255.0f alpha:1.0f];
        self.sizeButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);

        UIImage *sizeImage = [UIImage imageNamed:@"DropdownButton.png"];
        UIImage *sizePressedImage = [UIImage imageNamed:@"DropdownButtonPressed.png"];
        UIEdgeInsets insets = UIEdgeInsetsMake(sizeImage.size.height/2, sizeImage.size.width/2, sizeImage.size.height/2, sizeImage.size.width/2);
        [self.sizeButton setBackgroundImage:[sizeImage resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
        [self.sizeButton setBackgroundImage:[sizePressedImage resizableImageWithCapInsets:insets] forState:UIControlStateHighlighted];
        
        UIImage *arrowImage = [UIImage imageNamed:@"Arrow.png"];
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:arrowImage];
        arrowView.frame = CGRectMake(140.0f, (40.0f - arrowImage.size.height)/2.0f, arrowImage.size.width, arrowImage.size.height);
        [self.sizeButton addSubview:arrowView];
        [self addSubview:self.sizeButton];
    }
}


@end
