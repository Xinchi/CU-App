//
//  AppDelegate.m
//  Chinese Union
//
//  Created by Max Gu on 6/3/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

//#import <BugSense-iOS/BugSenseController.h>
#import <Appsee/Appsee.h>
#import <ALAlertBanner/ALAlertBanner.h>
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "CUMainViewController.h"
#import "UIImage+MDQRCode.h"
#import "CUMembers.h"
#import "CUEvents.h"
#import "CUProducts.h"
#import "User.h"
#import "Reachability.h"
#import "CUBasketballPlayer.h"
#import "CUSoccerPlayer.h"
#import "CUPersonnel.h"
#import "ServiceCallManager.h"
#import "RESideMenu.h"
#import "Common.h"
#import "Order.h"
#import "Aspects.h"
#import "PAPUtility.h"
#import "CUNavigationController.h"
#import "CUOfficers.h"
#if DEBUG
#import "FLEXManager.h"
#endif

@interface AppDelegate ()
{
    NSMutableData *_data;
}

@property (nonatomic, strong) UIViewController          *mainViewController;
@property (nonatomic, strong) ProfileViewController     *menuViewController;
@property (nonatomic, strong) RESideMenu *sideMenuViewController;
@property (nonatomic, strong) Reachability              *reach;
@property (nonatomic, strong) ALAlertBanner             *noConnectionBanner;
@property (nonatomic, strong) ALAlertBanner             *hasConnectionBanner;

@end

@implementation AppDelegate

@synthesize window;
@synthesize delegate;
@synthesize networkStatus;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MyLog(@"[AppDelegate didFinishLaunchingWithOptions");
    //Setup
    [self customizeTableView];
    [self setupAppearance];
    [Parse setApplicationId:@"TMkpbVAQb00DIAVcYnIK7jnL6qGxlBPepygCUClI"
                  clientKey:@"5Y5wflzXCSajnw3fksrIrv9V5gkIbLi7v15v007r"];
    
    //[BugSenseController sharedControllerWithBugSenseAPIKey:@"fdc41c40"];
    [Appsee start:@"fa1fbc2f07994a42abf777db222bd85a"];
    
//    // Tracking Pushes and App Opens
//    if (application.applicationState != UIApplicationStateBackground) {
//        // Track an app open here if we launch with a push, unless
//        // "content_available" was used to trigger a background push (introduced
//        // in iOS 7). In that case, we skip tracking here to avoid double
//        // counting the app-open.
//        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
//        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
//        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
//            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
//        }
//    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blur_background"]];

    //[self customizedNavigation];
    [self registerPFSubclass];

    [PFFacebookUtils initializeFacebook];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    self.menuViewController = [[ProfileViewController alloc] init];
//    self.mainViewController = [[TWTMainViewController alloc] initWithNibName:nil bundle:nil];
    self.mainViewController = [[CUMainViewController alloc] initWithNibName:@"CUMainViewController" bundle:nil];
    
    // create a new side menu
    CUNavigationController *nav = [[CUNavigationController alloc] initWithRootViewController:self.mainViewController];
//    [nav.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
//    self.sideMenuViewController = [[RESideMenu alloc] initWithMenuViewController:self.menuViewController mainViewController:nav];
    self.sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:nav leftMenuViewController:self.menuViewController rightMenuViewController:nil];
    self.sideMenuViewController.menuPreferredStatusBarStyle = self.sideMenuViewController.leftMenuViewController.preferredStatusBarStyle;
    
    
    //side menu controller configuration
//    self.sideMenuViewController.shadowColor = [UIColor blackColor];
//    self.sideMenuViewController.edgeOffset = (UIOffset) { .horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 18.0f : 0.0f };
//    self.sideMenuViewController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 0.5634f : 0.85f;
//    self.sideMenuViewController.delegate = self;
    
    // set the side menu controller as the root view controller
    
    
    self.window.rootViewController = self.sideMenuViewController;
    
//    // Override point for customization after application launch.
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[SubclassConfigViewController alloc] init]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    NSInteger number= 10;
//    [self createMembers:number];
    [self handlePush:launchOptions];

    [self test];
    [self addReachability];
    
#if DEBUG
    //[[FLEXManager sharedManager] showExplorer];
#endif

    return YES;
}


- (void)handlePush:(NSDictionary *)launchOptions {
    MyLog(@"handlePush");
    // If the app was launched in response to a push notification, we'll handle the payload here
    NSDictionary *remoteNotificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationPayload) {
//        [Common showAlertTitle:@"Push" msg:@"remoteNotificationPayload !+ null" onView:self.mainViewController.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:PAPAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:remoteNotificationPayload];
        if([User currentUser])
        {
            [delegate didReceiveRemoteNotificationPayload:remoteNotificationPayload];
        }
        
    }
}
- (void)test {
//    [ServiceCallManager getAllPurchaseHistoryWithBlock:^(NSArray *objects, NSError *error) {
//        if(!error)
//        {
//            MyLog(@"getAllPurchaseHistoryWithBlock is successful and no error has been returned");
//            MyLog(@"array size = %lu", (unsigned long)[objects count]);
//            for(id object in objects){
//                Order *order = (Order *)object;
//                MyLog(@"Order id = %@ and the order item is %@", order.objectId, order.product);
//            }
//        } else {
//            NSString *msg = [Common getUsefulErrorMessage:error];
//            MyLog(@"%@",msg);
//        }
//        
//    }];
//    PFQuery *query = [Orders query];
//    [query getObjectInBackgroundWithId:@"6O2F8hYgvu" block:^(PFObject *object, NSError *error) {
//        if(!error)
//        {
//            Orders *order = (Orders *)object;
//            [order.customer fetch];
//            MyLog(@"customer id = %@", order.customer.objectId);
//        } else {
//            MyLog(@"%@",[Common getUsefulErrorMessage:error]);
//        }
//    }];
    
    [ServiceCallManager getCurrentDateWithBlock:^(NSDate *date, NSError *error) {
        if(!error)
        {
            MyLog(@"Time = %@",date);
        } else {
            MyLog(@"%@",[Common getUsefulErrorMessage:error]);
        }
    }];

}
- (void)addReachability {
    self.reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    __weak AppDelegate *weakSelf = self;
    
    self.reach.reachableBlock = ^(Reachability *reachability)
    {
        MyLog(@"Internet connected!");
        if (weakSelf.noConnectionBanner) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.noConnectionBanner hide];
                weakSelf.noConnectionBanner = nil;
                
                weakSelf.hasConnectionBanner = [ALAlertBanner alertBannerForView:weakSelf.window
                                                                           style:ALAlertBannerStyleSuccess
                                                                        position:ALAlertBannerPositionBottom
                                                                           title:NSLocalizedString(@"Internet connected!", @"")
                                                                        subtitle:nil];
                [weakSelf.hasConnectionBanner show];
            });
        }
    };
    
    self.reach.unreachableBlock = ^(Reachability * reachability)
    {
        MyLog(@"Connection loss!");
        if (!weakSelf.noConnectionBanner) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.noConnectionBanner = [ALAlertBanner alertBannerForView:weakSelf.window
                                                              style:ALAlertBannerStyleWarning
                                                           position:ALAlertBannerPositionBottom
                                                              title:NSLocalizedString(@"Internet connection lost!", @"")
                                                           subtitle:nil];
                weakSelf.noConnectionBanner.secondsToShow = 0; // Always shows
                [weakSelf.noConnectionBanner show];
            });
        }
    };
    
    [self.reach startNotifier];
}

- (void)customizedNavigation {
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Light" size:18.0]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    //[[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

- (void)customizeTableView
{
    [UITableView aspect_hookSelector:@selector(awakeFromNib)
                         withOptions:AspectPositionAfter
                          usingBlock:^(id<AspectInfo> aspectInfo){
                              UITableView *tableView = aspectInfo.instance;
                              UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:tableView.bounds];
                              texturedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLeather"]];
                              tableView.backgroundView = texturedBackgroundView;
                          }
                               error:nil];
}

- (void)createMembers: (NSInteger)n
{
//    User *user = [User currentUser];
//    if(user)
//    {
//        MyLog(@"CU member id = %@",user.CUMemberID);
//        if(user.CUMemberID !=nil)
//        {
//            MyLog(@"This is a CU Member");
//        }
//        else
//            MyLog(@"This is not a CU Member");
//    }

    for(int i = 0;i<n;i++)
    {
        PFACL *postACL = [PFACL ACL];
        [postACL setPublicReadAccess:YES];
        [postACL setPublicWriteAccess:YES];
        CUMembers *cuMember = [CUMembers object];
        cuMember.ACL = postACL;
        [cuMember saveInBackground];
    }

}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[PFInstallation currentInstallation] saveEventually];
    }
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)registerPFSubclass
{
    [CUMembers registerSubclass];
    [CUEvents registerSubclass];
    [CUProducts registerSubclass];
    [User registerSubclass];
    [CUBasketballPlayer registerSubclass];
    [CUSoccerPlayer registerSubclass];
    [CUPersonnel registerSubclass];
    [CUOfficers registerSubclass];
    [Order registerSubclass];
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}


- (void)setupAppearance {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.498f green:0.388f blue:0.329f alpha:1.0f]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor],UITextAttributeTextColor,
                                                          [UIColor colorWithWhite:0.0f alpha:0.750f],UITextAttributeTextShadowColor,
                                                          [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)],UITextAttributeTextShadowOffset,
                                                          nil]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"backgroundNavigationBar"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageNamed:@"buttonNavigationBar"] forState:UIControlStateNormal];
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage imageNamed:@"buttonNavigationBarSelected"] forState:UIControlStateHighlighted];
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleColor:[UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"back_button"]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"back_button_pressed"]
                                                      forState:UIControlStateSelected
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithRed:214.0f/255.0f green:210.0f/255.0f blue:197.0f/255.0f alpha:1.0f],UITextAttributeTextColor,
                                                          [UIColor colorWithWhite:0.0f alpha:0.750f],UITextAttributeTextShadowColor,
                                                          [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)],UITextAttributeTextShadowOffset,
                                                          nil] forState:UIControlStateNormal];
    
    [[UISearchBar appearance] setTintColor:[UIColor colorWithRed:32.0f/255.0f green:19.0f/255.0f blue:16.0f/255.0f alpha:1.0f]];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    MyLog(@"didRegisterForRemoteNotificationsWithDeviceToken:%@",newDeviceToken);
    [PFPush storeDeviceToken:newDeviceToken];
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
    
    [[PFInstallation currentInstallation] addUniqueObject:@"" forKey:kPAPInstallationChannelsKey];
    if ([PFUser currentUser]) {
        // Make sure they are subscribed to their private push channel
        NSString *privateChannelName = [[PFUser currentUser] objectForKey:kPAPUserPrivateChannelKey];
        if (privateChannelName && privateChannelName.length > 0) {
            NSLog(@"Subscribing user to %@", privateChannelName);
            [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kPAPInstallationChannelsKey];
        }
    }
    [[PFInstallation currentInstallation] saveEventually];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    MyLog(@"didFailToRegisterForRemoteNotificationsWithError: %@",error);
    if ([error code] != 3010) { // 3010 is for the iPhone Simulator
        NSLog(@"Application failed to register for push notifications: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    MyLog(@"AppDelegate application didReceiveRemoteNotification userInfo");
    
//    if (application.applicationState == UIApplicationStateInactive) {
//        // The application was just brought from the background to the foreground,
//        // so we consider the app as having been "opened by a push notification."
//    [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];

    [delegate didReceiveRemoteNotification:userInfo];
    
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [PAPUtility processFacebookProfilePictureData:_data];
}

#pragma mark - AppDelegate

- (BOOL)isParseReachable {
    MyLog(@"isParseReachable");
    networkStatus = [self.reach currentReachabilityStatus];
    return self.networkStatus != NotReachable;
}

//Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification* )note {
    Reachability *curReach = (Reachability *)[note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NSLog(@"Reachability changed: %@", curReach);
//    networkStatus = [curReach currentReachabilityStatus];
    networkStatus = [self.reach currentReachabilityStatus];
    
//    if ([self isParseReachable] && [PFUser currentUser] && self.homeViewController.objects.count == 0) {
//        // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
//        // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
//        [self.homeViewController loadObjects];
//    }
}


@end
