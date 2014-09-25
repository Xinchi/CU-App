//
//  PAPWelcomeViewController.m
//  Anypic
//
//  Created by Héctor Ramos on 5/10/12.
//

#import "PAPWelcomeViewController.h"
#import "AppDelegate.h"
#import "PAPLogInViewController.h"
#import "PAPTabBarController.h"
#import "PAPHomeViewController.h"
#import "PAPActivityFeedViewController.h"
#import "Common.h"

@interface PAPWelcomeViewController ()
@property (nonatomic, strong) PAPHomeViewController *homeViewController;
@property (nonatomic, strong) PAPActivityFeedViewController *activityViewController;

@end

@implementation PAPWelcomeViewController

@synthesize tabBarController;
@synthesize homeViewController;


#pragma mark - UIViewController
- (void)loadView {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [backgroundImageView setImage:[UIImage imageNamed:@"Default_anypic.png"]];
    self.view = backgroundImageView;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // If not logged in, present login view controller
    if (![PFUser currentUser]) {
//        [self presentLoginViewControllerAnimated:NO];
//        return;
        [Common showAlertTitle:@"Error" msg:@"Not logged in" onView:self.navigationController.view];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    // Present Anypic UI
    [self presentTabBarController];
    
    // Refresh current user with server side data -- checks if user is still valid and so on
//    [[PFUser currentUser] refreshInBackgroundWithTarget:self selector:@selector(refreshCurrentUserCallbackWithResult:error:)];
}


#pragma mark - ()

- (void)refreshCurrentUserCallbackWithResult:(PFObject *)refreshedObject error:(NSError *)error {
    // A kPFErrorObjectNotFound error on currentUser refresh signals a deleted user
    if (error && error.code == kPFErrorObjectNotFound) {
        NSLog(@"User does not exist.");
//        [(AppDelegate*)[[UIApplication sharedApplication] delegate] logOut];
        return;
    }
    

    // Check if user is missing a Facebook ID
    if ([PAPUtility userHasValidFacebookData:[PFUser currentUser]]) {
        // User has Facebook ID.

        // refresh Facebook friends on each launch
//        [[PFFacebookUtils facebook] requestWithGraphPath:@"me/friends" andDelegate:(AppDelegate*)[[UIApplication sharedApplication] delegate]];
        
        [FBRequestConnection startWithGraphPath:@"/me/friends"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error){
                                      NSDictionary *friends= result;
                                      MyLog(@"friends = %@",friends);
                                  } else {
                                      // There was an error, handle it
                                      // See https://developers.facebook.com/docs/ios/errors/
                                  }
        }];
        
        
    } else {
        NSLog(@"User missing Facebook ID");
//        [[PFFacebookUtils facebook] requestWithGraphPath:@"me/?fields=name,picture,email" andDelegate:(AppDelegate*)[[UIApplication sharedApplication] delegate]];
        [FBRequestConnection startWithGraphPath:@"me/?fields=name,picture,email" completionHandler:nil];
    }
    

}


- (void)presentLoginViewControllerAnimated:(BOOL)animated {
    PAPLogInViewController *loginViewController = [[PAPLogInViewController alloc] init];
    [loginViewController setDelegate:self];
    loginViewController.fields = PFLogInFieldsFacebook;
    loginViewController.facebookPermissions = [NSArray arrayWithObjects:@"user_about_me", nil];
//    
//    [self.welcomeViewController presentModalViewController:loginViewController animated:NO];
    [self presentViewController:loginViewController animated:NO completion:nil];
}

- (void)presentTabBarController {
    self.tabBarController = [[PAPTabBarController alloc] init];
    self.homeViewController = [[PAPHomeViewController alloc] initWithStyle:UITableViewStylePlain];
//    [self.homeViewController setFirstLaunch:firstLaunch];
    self.activityViewController = [[PAPActivityFeedViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    UINavigationController *emptyNavigationController = [[UINavigationController alloc] init];
    UINavigationController *activityFeedNavigationController = [[UINavigationController alloc] initWithRootViewController:self.activityViewController];
    
    [PAPUtility addBottomDropShadowToNavigationBarForNavigationController:homeNavigationController];
    [PAPUtility addBottomDropShadowToNavigationBarForNavigationController:emptyNavigationController];
    [PAPUtility addBottomDropShadowToNavigationBarForNavigationController:activityFeedNavigationController];
    
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"IconHome.png"]  tag:0];
//    [homeTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"IconHomeSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"IconHome.png"]];
    [homeTabBarItem initWithTitle:@"Home" image:[UIImage imageNamed:@"IconHome.png"] selectedImage:[UIImage imageNamed:@"IconHomeSelected.png"]];
    
    [homeTabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor colorWithRed:86.0f/255.0f green:55.0f/255.0f blue:42.0f/255.0f alpha:1.0f], UITextAttributeTextColor,
                                            nil] forState:UIControlStateNormal];
    [homeTabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor colorWithRed:129.0f/255.0f green:99.0f/255.0f blue:69.0f/255.0f alpha:1.0f], UITextAttributeTextColor,
                                            nil] forState:UIControlStateSelected];
    
    UITabBarItem *activityFeedTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Activity" image:nil tag:0];
    [activityFeedTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"IconTimelineSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"IconTimeline.png"]];
    [activityFeedTabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor colorWithRed:86.0f/255.0f green:55.0f/255.0f blue:42.0f/255.0f alpha:1.0f], UITextAttributeTextColor,
                                                    nil] forState:UIControlStateNormal];
    [activityFeedTabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor colorWithRed:129.0f/255.0f green:99.0f/255.0f blue:69.0f/255.0f alpha:1.0f], UITextAttributeTextColor,
                                                    nil] forState:UIControlStateSelected];
    
    [homeNavigationController setTabBarItem:homeTabBarItem];
    [activityFeedNavigationController setTabBarItem:activityFeedTabBarItem];
    
    [self.tabBarController setDelegate:self];
    [self.tabBarController setViewControllers:[NSArray arrayWithObjects:homeNavigationController, emptyNavigationController, activityFeedNavigationController, nil]];
    
//    [self.navigationController setViewControllers:[NSArray arrayWithObjects:self, self.tabBarController, nil] animated:NO];
    [self.navigationController pushViewController:self.tabBarController animated:NO];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    
    NSLog(@"Downloading user's profile picture");
    // Download user's profile picture
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:kPAPUserFacebookIDKey]]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
}
@end
