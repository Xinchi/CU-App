//
//  PAPWelcomeViewController.h
//  Anypic
//
//  Created by Héctor Ramos on 5/10/12.
//
@class PAPTabBarController;
@interface PAPWelcomeViewController : UIViewController<PFLogInViewControllerDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) PAPTabBarController *tabBarController;

@end
