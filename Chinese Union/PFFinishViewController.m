//
//  PFFinishViewController.m
//  Store
//
//  Created by Andrew Wang on 2/26/13.
//

#import "PFFinishViewController.h"
#import "PFProductsViewController.h"
#import "PFShippingViewController.h"
#import "NSArray+Additions.h"

@interface PFFinishViewController ()
@property (nonatomic, strong) PFObject *product;
@end

@implementation PFFinishViewController

#pragma mark - Life cycle

- (id)initWithProduct:(PFObject *)product {
    if (self = [super init]) {
        self.product = product;
    }
    return self;
}


#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    UIImage *backgroundStripe = [UIImage imageNamed:@"TopBarBg.png"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, backgroundStripe.size.height)];
    headerView.backgroundColor = [UIColor colorWithPatternImage:backgroundStripe];
    [self.view addSubview:headerView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"Thank you!", @"Thank you!");
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19.0f];
    titleLabel.textColor = [UIColor colorWithRed:132.0f/255.0f green:140.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    titleLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    titleLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake((self.view.frame.size.width - titleLabel.frame.size.width)/2.0f, (backgroundStripe.size.height - titleLabel.frame.size.height)/2.0f, titleLabel.frame.size.width, titleLabel.frame.size.height);
    [self.view addSubview:titleLabel];
    
    UIImage *confirmation = [UIImage imageNamed:@"IconConfirmation.png"];
    UIImageView *confirmationView = [[UIImageView alloc] initWithImage:confirmation];
    confirmationView.frame = CGRectMake((self.view.frame.size.width - confirmation.size.width)/2.0f, 100.0f, confirmation.size.width, confirmation.size.height);
    [self.view addSubview:confirmationView];
    
    UILabel *congratulationsLabel = [[UILabel alloc] init];
    congratulationsLabel.text = NSLocalizedString(@"Congratulations!", @"Congratulations!");
    congratulationsLabel.backgroundColor = [UIColor clearColor];
    congratulationsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:26.0f];
    congratulationsLabel.textColor = [UIColor colorWithRed:132.0f/255.0f green:140.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    congratulationsLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    congratulationsLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    [congratulationsLabel sizeToFit];
    congratulationsLabel.frame = CGRectMake((self.view.frame.size.width - congratulationsLabel.frame.size.width)/2.0f, 250.0f, congratulationsLabel.frame.size.width, congratulationsLabel.frame.size.height);
    [self.view addSubview:congratulationsLabel];
    
    UILabel *ownerLabel = [[UILabel alloc] init];
    ownerLabel.text = [NSString stringWithFormat:@"You are now the proud owner of\na CU %@.", self.product[@"description"]];
    ownerLabel.numberOfLines = 2;
    ownerLabel.textAlignment = NSTextAlignmentCenter;
    ownerLabel.backgroundColor = [UIColor clearColor];
    ownerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f];
    ownerLabel.textColor = [UIColor colorWithRed:132.0f/255.0f green:140.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
    ownerLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7];
    ownerLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    [ownerLabel sizeToFit];
    ownerLabel.frame = CGRectMake((self.view.frame.size.width - ownerLabel.frame.size.width)/2.0f, 300.0f, ownerLabel.frame.size.width, ownerLabel.frame.size.height);
    [self.view addSubview:ownerLabel];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setTitle:NSLocalizedString(@"Finish", @"Finish") forState:UIControlStateNormal];
    buyButton.titleLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    buyButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -0.5f);
    buyButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f];
    
    UIImage *checkoutImage = [UIImage imageNamed:@"ButtonCheckout.png"];
    UIImage *checkoutPressedImage = [UIImage imageNamed:@"ButtonCheckoutPressed.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(checkoutImage.size.height/2, checkoutImage.size.width/2, checkoutImage.size.height/2, checkoutImage.size.width/2);
    [buyButton setBackgroundImage:[checkoutImage resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
    [buyButton setBackgroundImage:[checkoutPressedImage resizableImageWithCapInsets:insets] forState:UIControlStateHighlighted];
    [buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    buyButton.frame = CGRectMake((self.view.frame.size.width - 195.0)/2.0f, 370.0f, 195.0f, checkoutImage.size.height);
    [self.view addSubview:buyButton];
}


#pragma mark - Event handlers

- (void)buy:(id)sender {
    // reset to the first view controller.
    NSArray *array = [self.navigationController viewControllers];
    if ([array containsObjectOfClass:[PFProductsViewController class]]) {
        NSUInteger idx = [array indexOfObjectOfClass:[PFProductsViewController class]];
        [self.navigationController popToViewController:array[idx] animated:YES];
    }
    else
    {
        NSInteger idx = [array indexOfObjectOfClass:[PFShippingViewController class]];
        if (idx == 0) {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
        else
        {
            if (idx - 1 >= 0) {
                [self.navigationController popToViewController:array[idx - 1] animated:YES];
            }
            else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
}

@end
