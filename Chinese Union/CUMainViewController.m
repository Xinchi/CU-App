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

    //register reachability
    [ReachabilityController registerForViewController:self];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blur_background"]];
    self.sideMenuViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blur_background"]];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"UCSD CU";
    
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
    
    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - CTSingUpViewControllerDelegate

- (void)signUpViewController:(UIViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self updateButtonTitle];

}

@end
