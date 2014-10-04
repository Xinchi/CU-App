//
//  CUMainViewController.m
//  Chinese Union
//
//  Created by wpliao on 2014/6/4.
//  Copyright (c) 2014年 ucsd.ChineseUnion. All rights reserved.
//

#import "CUMainViewController.h"
#import "CustomDataSource.h"
#import "MosaicLayout.h"
#import "MosaicData.h"
#import "MosaicLayout/Views/MosaicCell.h"
//#import "TWTSideMenuViewController.h"
#import "RESideMenu.h"
#import "MySignUpViewController.h"
#import "MyLogInViewController.h"
#import "SignUpViewController.h"
#import "CULoginViewController.h"
#import "User.h"
#import "PFProductsViewController.h"
#import "Reachability.h"
#import "ReachabilityController.h"
#import "CUEventViewController.h"
#import "CUContactTableViewController.h"
#import "CUYearSelectionTableViewController.h"
#import "PAPTabBarController.h"
#import "PAPHomeViewController.h"
#import "PAPActivityFeedViewController.h"
#import "Common.h"
#import "PAPUtility.h"
#import "PAPPhotoDetailsViewController.h"
#import "PAPAccountViewController.h"
#import "ServiceCallManager.h"

#define kDoubleColumnProbability 40
#define kColumnsiPadLandscape 5
#define kColumnsiPadPortrait 4
#define kColumnsiPhoneLandscape 3
#define kColumnsiPhonePortrait 2

@interface CUMainViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) CustomDataSource *dataSource;
@property (nonatomic, strong) PAPHomeViewController *homeViewController;
@property (nonatomic, strong) PAPActivityFeedViewController *activityViewController;

@end

@implementation CUMainViewController

@synthesize tabBarController;
@synthesize homeViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //setting up delegates
    [ServiceCallManager setMainViewController:self];
    
    AppDelegate *allDelegate = [[UIApplication sharedApplication] delegate];
    allDelegate.delegate = self;
    
    //set up anypic
    [self configureTabBar];
    
    //register reachability
    [ReachabilityController registerForViewController:self];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blur_background"]];
    self.sideMenuViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blur_background"]];
    
    // Do any additional setup after loading the view from its nib.
    [[self getConfigSignal] subscribeNext:^(PFConfig *x) {
        self.title = x[@"AppTitle"];
        [self.collectionView reloadData];
    } error:^(NSError *error) {
        PFConfig *currentConfig = [PFConfig currentConfig];
        self.title = currentConfig[@"AppTitle"] ? : @"UCSD CU";
    }];
    
    [PFConfig currentConfig];
    
    self.dataSource = [[CustomDataSource alloc] init];
    self.collectionView.dataSource = self.dataSource;

    UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    self.navigationItem.leftBarButtonItem = openItem;
    [self updateButtonTitle];
    
    [self.collectionView registerClass:[MosaicCell class] forCellWithReuseIdentifier:@"cell"];
    [(MosaicLayout *)self.collectionView.collectionViewLayout setDelegate:self];
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.collectionView.bounds];
    texturedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLeather"]];
    self.collectionView.backgroundView = texturedBackgroundView;
}

- (RACSignal *)getConfigSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [ServiceCallManager getAppConfigWithBlock:^(PFConfig *config, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else
            {
                [subscriber sendNext:config];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateButtonTitle];
}

- (void)updateButtonTitle {
    bool loggedin = [User currentUser];
    if (loggedin) {
        self.navigationItem.leftBarButtonItem.title = @"Account";
    }
    else {
        self.navigationItem.leftBarButtonItem.title = @"Login";
    }
}

#pragma mark - Button

- (void)openButtonPressed
{
    if([User currentUser])
//        [self.sideMenuViewController openMenuAnimated:YES completion:nil];
        [self.sideMenuViewController presentLeftMenuViewController];
    else{
//        // Customize the Log In View Controller
//        MyLogInViewController *logInViewController = [[MyLogInViewController alloc] init];
//        logInViewController.delegate = self;
//        logInViewController.facebookPermissions = @[@"friends_about_me"];
//        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton | PFLogInFieldsDismissButton;
//        
//        // Customize the Sign Up View Controller
//        MySignUpViewController *signUpViewController = [[MySignUpViewController alloc] init];
//        signUpViewController.delegate = self;
//        signUpViewController.fields = PFSignUpFieldsDefault | PFSignUpFieldsAdditional;
//        logInViewController.signUpController = signUpViewController;
//        
//        // Present Log In View Controller
//        [self presentViewController:logInViewController animated:YES completion:NULL];
        CULoginViewController *loginVC = [[CULoginViewController alloc] init];
        loginVC.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        
//        SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
//        [self presentViewController:signUpVC animated:YES completion:nil];

    }
}

#pragma mark - MosaicLayoutDelegate

-(float)collectionView:(UICollectionView *)collectionView relativeHeightForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //  Base relative height for simple layout type. This is 1.0 (height equals to width)
    float retVal = 1.0;
    
//    NSMutableArray *elements = [(CustomDataSource *)self.collectionView.dataSource elements];
//    MosaicData *aMosaicModule = [elements objectAtIndex:indexPath.row];
//    
//    if (aMosaicModule.relativeHeight != 0){
//        
//        //  If the relative height was set before, return it
//        retVal = aMosaicModule.relativeHeight;
//        
//    }else{
//        
//        BOOL isDoubleColumn = [self collectionView:collectionView isDoubleColumnAtIndexPath:indexPath];
//        if (isDoubleColumn){
//            //  Base relative height for double layout type. This is 0.75 (height equals to 75% width)
//            retVal = 0.75;
//        }
//        
//        /*  Relative height random modifier. The max height of relative height is 25% more than
//         *  the base relative height */
//        
//        //float extraRandomHeight = arc4random() % 25;
//        //retVal = retVal + (extraRandomHeight / 100);
//        
//        /*  Persist the relative height on MosaicData so the value will be the same every time
//         *  the mosaic layout invalidates */
//        
//        aMosaicModule.relativeHeight = retVal;
//    }
    
    return retVal;
}

-(BOOL)collectionView:(UICollectionView *)collectionView isDoubleColumnAtIndexPath:(NSIndexPath *)indexPath{
//    NSMutableArray *elements = [(CustomDataSource *)self.collectionView.dataSource elements];
//    MosaicData *aMosaicModule = [elements objectAtIndex:indexPath.row];
//    
//    if (aMosaicModule.layoutType == kMosaicLayoutTypeUndefined){
//        
//        /*  First layout. We have to decide if the MosaicData should be
//         *  double column (if possible) or not. */
//        
//        NSUInteger random = arc4random() % 100;
//        if (random < kDoubleColumnProbability){
//            aMosaicModule.layoutType = kMosaicLayoutTypeDouble;
//        }else{
//            aMosaicModule.layoutType = kMosaicLayoutTypeSingle;
//        }
//    }
//    
//    BOOL retVal = aMosaicModule.layoutType == kMosaicLayoutTypeDouble;
//    
//    return retVal;
    return NO;
    
}

-(NSUInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView{
    
//    UIInterfaceOrientation anOrientation = self.interfaceOrientation;
//    
//    //  Set the quantity of columns according of the device and interface orientation
//    NSUInteger retVal = 0;
//    if (UIInterfaceOrientationIsLandscape(anOrientation)){
//        
//        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
//            retVal = kColumnsiPadLandscape;
//        }else{
//            retVal = kColumnsiPhoneLandscape;
//        }
//        
//    }else{
//        
//        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
//            retVal = kColumnsiPadPortrait;
//        }else{
//            retVal = kColumnsiPhonePortrait;
//        }
//    }
//    
//    return retVal;
    return 2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    UIViewController *VC;
    
    if (indexPath.row == 0) {
        VC = [[CUEventViewController alloc] init];
    }
    else if (indexPath.row == 1) {
        VC = [[PFProductsViewController alloc] init];
    }
    else if (indexPath.row == 2) {
        VC = [[CUYearSelectionTableViewController alloc] init];
        ((CUYearSelectionTableViewController *)VC).contactType = SOCCER;
    }
    else if (indexPath.row == 3) {
        VC = [[CUYearSelectionTableViewController alloc] init];
        ((CUYearSelectionTableViewController *)VC).contactType = BASKETBALL;
    }
    else if (indexPath.row == 4) {
        VC = [[CUYearSelectionTableViewController alloc] init];
        ((CUYearSelectionTableViewController *)VC).contactType = PERSONNEL;
    }
    else if (indexPath.row == 5) {
        if(![User currentUser])
        {
            [Common showAlertTitle:@"Error" msg:@"Please log in first" onView:self.navigationController.view];
            return;
        }
        // In case user swithces his account and new tabbar needs to be initialized here 
        if(self.tabBarController == nil)
        {
            [self configureTabBar];
        }
        VC = self.tabBarController;
    }
    
    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - CTSingUpViewControllerDelegate

- (void)signUpViewController:(UIViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self updateButtonTitle];

}


- (void)configureTabBar {
    MyLog(@"configureTabBar");
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
    
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"iconHome"]  tag:0];
    //    [homeTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"IconHomeSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"iconHome.png"]];
    [homeTabBarItem initWithTitle:@"Home" image:[UIImage imageNamed:@"iconHome"] selectedImage:[UIImage imageNamed:@"IconHomeSelected"]];
    
    [homeTabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor colorWithRed:86.0f/255.0f green:55.0f/255.0f blue:42.0f/255.0f alpha:1.0f], UITextAttributeTextColor,
                                            nil] forState:UIControlStateNormal];
    [homeTabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor colorWithRed:129.0f/255.0f green:99.0f/255.0f blue:69.0f/255.0f alpha:1.0f], UITextAttributeTextColor,
                                            nil] forState:UIControlStateSelected];
    
    UITabBarItem *activityFeedTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Activity" image:nil tag:0];
    [activityFeedTabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"IconTimelineSelected"] withFinishedUnselectedImage:[UIImage imageNamed:@"iconTimeline"]];
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
//    [self.navigationController pushViewController:self.tabBarController animated:NO];
    
    MyLog(@"About to call registerForRemoteNotificationTypes");
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
//     UIRemoteNotificationTypeAlert|
//     UIRemoteNotificationTypeSound];
    
    if ([[UIApplication sharedApplication]respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        MyLog(@"iOS 8 Remote Notification Registration");
        // iOS 8 Notifications
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        MyLog(@"iOS 7 Remote Notification Registration");

        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    
    
    
    NSLog(@"Downloading user's profile picture");
    // Download user's profile picture
    NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [[PFUser currentUser] objectForKey:kPAPUserFacebookIDKey]]];
    NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f]; // Facebook profile picture cache policy: Expires in 2 weeks
    [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)aTabBarController shouldSelectViewController:(UIViewController *)viewController {
    // The empty UITabBarItem behind our Camera button should not load a view controller
    return ![viewController isEqual:[[aTabBarController viewControllers] objectAtIndex:PAPEmptyTabBarItemIndex]];
}

#pragma mark - RemoteNotificationDelegate

- (void)didReceiveRemoteNotification: (NSDictionary *)userInfo
{
    MyLog(@"[CUMainViewController didReceiveRemoteNotification]");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PAPAppDelegateApplicationDidReceiveRemoteNotification object:nil userInfo:userInfo];
    
    if ([PFUser currentUser]) {
        if ([self.tabBarController viewControllers].count > PAPActivityTabBarItemIndex) {
            UITabBarItem *tabBarItem = [[[self.tabBarController viewControllers] objectAtIndex:PAPActivityTabBarItemIndex] tabBarItem];
            
            NSString *currentBadgeValue = tabBarItem.badgeValue;
            if (currentBadgeValue && currentBadgeValue.length > 0) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                NSNumber *badgeValue = [numberFormatter numberFromString:currentBadgeValue];
                NSNumber *newBadgeValue = [NSNumber numberWithInt:[badgeValue intValue] + 1];
                tabBarItem.badgeValue = [numberFormatter stringFromNumber:newBadgeValue];
                MyLog(@"At Possible place 4, badgeValue has been set to %@", tabBarItem.badgeValue);
            } else {
                
                tabBarItem.badgeValue = @"1";
            }
            MyLog(@"currentBadgeValue = %@", tabBarItem.badgeValue);
        }
    }
}

- (void) didReceiveRemoteNotificationPayload:(NSDictionary *)remoteNotificationPayload
{
    if ([PFUser currentUser]) {
        // if the push notification payload references a photo, we will attempt to push this view controller into view
        NSString *photoObjectId = [remoteNotificationPayload objectForKey:kPAPPushPayloadPhotoObjectIdKey];
        NSString *fromObjectId = [remoteNotificationPayload objectForKey:kPAPPushPayloadFromUserObjectIdKey];
        if (photoObjectId && photoObjectId.length > 0) {
            // check if this photo is already available locally.
            
            PFObject *targetPhoto = [PFObject objectWithoutDataWithClassName:kPAPPhotoClassKey objectId:photoObjectId];
            for (PFObject *photo in [self.homeViewController objects]) {
                if ([[photo objectId] isEqualToString:photoObjectId]) {
                    NSLog(@"Found a local copy");
                    targetPhoto = photo;
                    break;
                }
            }
            
            // if we have a local copy of this photo, this won't result in a network fetch
            [targetPhoto fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    UINavigationController *homeNavigationController = [[self.tabBarController viewControllers] objectAtIndex:PAPHomeTabBarItemIndex];
                    [self.tabBarController setSelectedViewController:homeNavigationController];
                    
                    PAPPhotoDetailsViewController *detailViewController = [[PAPPhotoDetailsViewController alloc] initWithPhoto:object];
                    [homeNavigationController pushViewController:detailViewController animated:YES];
                }
            }];
        } else if (fromObjectId && fromObjectId.length > 0) {
            // load fromUser's profile
            
            PFQuery *query = [PFUser query];
            query.cachePolicy = kPFCachePolicyCacheElseNetwork;
            [query getObjectInBackgroundWithId:fromObjectId block:^(PFObject *user, NSError *error) {
                if (!error) {
                    UINavigationController *homeNavigationController = [[self.tabBarController viewControllers] objectAtIndex:PAPHomeTabBarItemIndex];
                    [self.tabBarController setSelectedViewController:homeNavigationController];
                    
                    PAPAccountViewController *accountViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
                    [accountViewController setUser:(User *)user];
                    [homeNavigationController pushViewController:accountViewController animated:YES];
                }
            }];
            
        }
    }

}

-(void) cleanupAfterLoggingOut
{
    MyLog(@"[CUMainViewController cleanupAfterLoggingout]");
    self.tabBarController = nil;
//    self.homeViewController = nil;
//    self.activityViewController = nil;
}

@end
