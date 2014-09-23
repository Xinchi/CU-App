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
#if DEBUG
#import "FLEXManager.h"
#endif

@interface AppDelegate ()

@property (nonatomic, strong) UIViewController          *mainViewController;
@property (nonatomic, strong) ProfileViewController     *menuViewController;
@property (nonatomic, strong) RESideMenu *sideMenuViewController;
@property (nonatomic, strong) Reachability              *reach;
@property (nonatomic, strong) ALAlertBanner             *noConnectionBanner;
@property (nonatomic, strong) ALAlertBanner             *hasConnectionBanner;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Setup
    [Parse setApplicationId:@"TMkpbVAQb00DIAVcYnIK7jnL6qGxlBPepygCUClI"
                  clientKey:@"5Y5wflzXCSajnw3fksrIrv9V5gkIbLi7v15v007r"];
    
    //[BugSenseController sharedControllerWithBugSenseAPIKey:@"fdc41c40"];
    [Appsee start:@"fa1fbc2f07994a42abf777db222bd85a"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blur_background"]];

    [self customizedNavigation];
    [self registerPFSubclass];

    [PFFacebookUtils initializeFacebook];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    self.menuViewController = [[ProfileViewController alloc] initWithNibName:nil bundle:nil];
//    self.mainViewController = [[TWTMainViewController alloc] initWithNibName:nil bundle:nil];
    self.mainViewController = [[CUMainViewController alloc] initWithNibName:@"CUMainViewController" bundle:nil];
    
    // create a new side menu
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
//    [nav.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
//    self.sideMenuViewController = [[RESideMenu alloc] initWithMenuViewController:self.menuViewController mainViewController:nav];
    self.sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:nav leftMenuViewController:self.menuViewController rightMenuViewController:nil];
    
    
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
    [self test];
    [self addReachability];
    
#if DEBUG
    [[FLEXManager sharedManager] showExplorer];
#endif

    return YES;
}

- (void)test {
    PFQuery* query = [CUSoccerPlayer query];
    [query getObjectInBackgroundWithId:@"ddaT7sWzZE" block:^(PFObject *object, NSError  *error){
        if(!error)
        {
            CUSoccerPlayer *player = (CUSoccerPlayer *)object;
            User *associatedPlayer = player.associatedPerson;
            [associatedPlayer fetchIfNeededInBackgroundWithBlock:^(PFObject* object, NSError *error){
               if(!error)
               {
                   MyLog(@"associatedPlayer name = %@",associatedPlayer.objectId);
               }
            }];
            
        }
    }];

}
- (void)addReachability {
    self.reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    __weak AppDelegate *weakSelf = self;
    
    self.reach.reachableBlock = ^(Reachability * reachability)
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
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}



@end
