//
//  AppDelegate.m
//  Chinese Union
//
//  Created by Max Gu on 6/3/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "TWTMenuViewController.h"
#import "TWTMainViewController.h"
#import "CUMainViewController.h"
#import "UIImage+MDQRCode.h"
#import "CUMembers.h"
#import "CUEvents.h"
#import "CUProducts.h"
#import "User.h"

@interface AppDelegate ()

@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) ProfileViewController *menuViewController;
@property (nonatomic, strong) TWTSideMenuViewController *sideMenuViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blur_background"]];

    [self registerPFSubclass];
    [Parse setApplicationId:@"TMkpbVAQb00DIAVcYnIK7jnL6qGxlBPepygCUClI"
                  clientKey:@"5Y5wflzXCSajnw3fksrIrv9V5gkIbLi7v15v007r"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    self.menuViewController = [[ProfileViewController alloc] initWithNibName:nil bundle:nil];
//    self.mainViewController = [[TWTMainViewController alloc] initWithNibName:nil bundle:nil];
    self.mainViewController = [[CUMainViewController alloc] initWithNibName:@"CUMainViewController" bundle:nil];
    
    // create a new side menu
    self.sideMenuViewController = [[TWTSideMenuViewController alloc] initWithMenuViewController:self.menuViewController mainViewController:[[UINavigationController alloc] initWithRootViewController:self.mainViewController]];
    
    
    //side menu controller configuration
    self.sideMenuViewController.shadowColor = [UIColor blackColor];
    self.sideMenuViewController.edgeOffset = (UIOffset) { .horizontal = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 18.0f : 0.0f };
    self.sideMenuViewController.zoomScale = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 0.5634f : 0.85f;
    self.sideMenuViewController.delegate = self;
    self.window.rootViewController = self.sideMenuViewController;
    
    // set the side menu controller as the root view controller
    self.window.rootViewController = self.sideMenuViewController;
    
    
    
//    // Override point for customization after application launch.
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[SubclassConfigViewController alloc] init]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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
}
@end
