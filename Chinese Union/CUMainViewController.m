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
#import "TWTSideMenuViewController.h"
#import "MySignUpViewController.h"
#import "MyLogInViewController.h"
#import "SignUpViewController.h"
#import "CULoginViewController.h"
#import "User.h"


#define kDoubleColumnProbability 40
#define kColumnsiPadLandscape 5
#define kColumnsiPadPortrait 4
#define kColumnsiPhoneLandscape 3
#define kColumnsiPhonePortrait 2

@interface CUMainViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) CustomDataSource *dataSource;

@end

@implementation CUMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"CU App";
    
    self.dataSource = [[CustomDataSource alloc] init];
    self.collectionView.dataSource = self.dataSource;

    UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    self.navigationItem.leftBarButtonItem = openItem;
    [self updateButtonTitle];
    
    [self.collectionView registerClass:[MosaicCell class] forCellWithReuseIdentifier:@"cell"];
    [(MosaicLayout *)self.collectionView.collectionViewLayout setDelegate:self];
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
        [self.sideMenuViewController openMenuAnimated:YES completion:nil];
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
    NSLog(@"Did select item:%@", indexPath);
//    switch (indexPath.row) {
//        case 0:
//            [self performSegueWithIdentifier:@"eventSegue" sender:self];
//            break;
//            
//        case 1:
//            [self performSegueWithIdentifier:@"storeSegue" sender:self];
//            break;
//            
//        case 2:
//            [self performSegueWithIdentifier:@"calendarSegue" sender:self];
//            break;
//            
//        case 3:
//            [self performSegueWithIdentifier:@"soccerSegue" sender:self];
//            break;
//            
//        case 4:
//            [self performSegueWithIdentifier:@"basketballSegue" sender:self];
//            break;
//            
//        case 5:
//            [self performSegueWithIdentifier:@"contactSegue" sender:self];
//            break;
//            
//        default:
//            break;
//    }
}

//<<<<<<< HEAD
#pragma mark - CTSingUpViewControllerDelegate

- (void)signUpViewController:(UIViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self updateButtonTitle];

}
//=======
#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(User *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self updateButtonTitle];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


//#pragma mark - PFSignUpViewControllerDelegate
//
//// Sent to the delegate to determine whether the sign up request should be submitted to the server.
//- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
//    BOOL informationComplete = YES;
//    for (id key in info) {
//        NSString *field = [info objectForKey:key];
//        if (!field || field.length == 0) {
//            informationComplete = NO;
//            break;
//        }
//    }
//    
//    if (!informationComplete) {
//        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
//    }
//    
//    return informationComplete;
//}
//
//// Sent to the delegate when a PFUser is signed up.
//- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(User *)user {
//>>>>>>> subclassing


//#pragma mark - PFLogInViewControllerDelegate
//
//// Sent to the delegate to determine whether the log in request should be submitted to the server.
//- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
//    if (username && password && username.length && password.length) {
//        return YES;
//    }
//    
//    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
//    return NO;
//}
//
//// Sent to the delegate when a PFUser is logged in.
//- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
//    [self dismissViewControllerAnimated:YES completion:NULL];
//    [self updateButtonTitle];
//}
//
//// Sent to the delegate when the log in attempt fails.
//- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
//    NSLog(@"Failed to log in...");
//}
//
//// Sent to the delegate when the log in screen is dismissed.
//- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
//    NSLog(@"User dismissed the logInViewController");
//}
//
//
//#pragma mark - PFSignUpViewControllerDelegate
//
//// Sent to the delegate to determine whether the sign up request should be submitted to the server.
//- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
//    BOOL informationComplete = YES;
//    for (id key in info) {
//        NSString *field = [info objectForKey:key];
//        if (!field || field.length == 0) {
//            informationComplete = NO;
//            break;
//        }
//    }
//    
//    if (!informationComplete) {
//        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
//    }
//    
//    return informationComplete;
//}
//
//// Sent to the delegate when a PFUser is signed up.
//- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
//    [self dismissViewControllerAnimated:YES completion:NULL];
//    [self updateButtonTitle];
//}
//
//// Sent to the delegate when the sign up attempt fails.
//- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
//    NSLog(@"Failed to sign up...");
//}
//
//// Sent to the delegate when the sign up screen is dismissed.
//- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
//    NSLog(@"User dismissed the signUpViewController");
//}

@end
