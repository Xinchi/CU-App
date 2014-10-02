//
//  SubclassConfigViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "ProfileViewController.h"
#import "MyLogInViewController.h"
#import "MySignUpViewController.h"
//#import "TWTSideMenuViewController/TWTSideMenuViewController.h"
#import "RESideMenu.h"
#import "User.h"
#import "CUMemberViewController.h"
#import "CUEditProfileViewController.h"
#import "NSDateFormatter+Additions.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "MRProgress.h"
#import "ReachabilityController.h"
#import "ServiceCallManager.h"
#import "Common.h"
#import "CUFullProfileViewController.h"
#import "UIViewController+Additions.h"
#import "CUPurchaseHistoryViewController.h"
#import "UIViewController+Additions.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;

@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation ProfileViewController

- (UIActionSheet *)actionSheet {
    if (_actionSheet == nil) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Log out" otherButtonTitles: nil];
    }
    return _actionSheet;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ReachabilityController registerForViewController:self];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blur_background"]];
    
    self.profilePicView.layer.cornerRadius = 8;
    self.profilePicView.layer.masksToBounds = YES;
    self.profilePicView.layer.borderWidth = 0;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    User *user = [User currentUser];
//    [user refresh];
    
    if (user) {
        self.userNameLabel.text = [NSString stringWithFormat:@"%@", user.username];
        self.realNameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        self.emailLabel.text    = [NSString stringWithFormat:@"%@", user.email];
        self.birthdayLabel.text = [NSString stringWithFormat:@"%@", [[NSDateFormatter birthdayFormatter] stringFromDate:user.birthday]];
        MyLog(@"User b day:%@", user.birthday);
        self.phoneLabel.text    = [NSString stringWithFormat:@"%@", user.phone];
        self.wechatLabel.text   = [NSString stringWithFormat:@"%@", user.wechatID ? user.wechatID : @"Not linked to WeChat"];
        self.profilePicView.image = nil;
        
        if (user.profilePic) {
            MyLog(@"User has profilePic!!");

            PFFile *profilePic = user.profilePic;

            [profilePic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error){
                if(!error)
                {
                    UIImage *proPic = [UIImage imageWithData:imageData];
                    MyLog(@"Successfully retrieved profilePic!");
                    self.profilePicView.image = proPic;
                }
            }];
        }
    } else {
        self.userNameLabel.text = NSLocalizedString(@"Not logged in", nil);
    }
    MyLog(@"emailVerified = %@", user.emailVerified ? @"YES" : @"NO");
    MyLog(@"objectId = %@", user.objectId);
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == self.actionSheet.destructiveButtonIndex) {
        [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
        [ServiceCallManager logOut];
        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
//        [self.sideMenuViewController closeMenuAnimated:YES completion:nil];
        [self.sideMenuViewController hideMenuViewController];
    }
}

#pragma mark - IBAction

- (IBAction)logOutButtonTapAction:(id)sender {
    [self.actionSheet showInView:self.view];
}

- (IBAction)editButtonPressed:(id)sender {
    CUEditProfileViewController *vc = [[CUEditProfileViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)memberButtonPressed:(id)sender {
    [ReachabilityController checkConnectionStatusForViewController:self];
//    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    CUMemberViewController *controller = [[CUMemberViewController alloc] init];
    controller.profileViewController = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)scannerButtonPressed:(UIButton *)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    // present and release the controller
    [self presentViewController:reader animated:YES completion:nil];
}

- (IBAction)myQRCodePressed:(UIButton *)sender {
    CUPurchaseHistoryViewController *vc = [[CUPurchaseHistoryViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [vc addExitButton];
    [self presentViewController:nav animated:YES completion:NULL];
}

#pragma mark - ZBarReaderDelegate

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    NSString *userId;
    MyLog(@"Finished reading QR code...");
    //Handle the data read in
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    for(ZBarSymbol *symbol in results)
    {
        userId = symbol.data;
        NSLog(@"FROM QR Scanning, userId = %@",userId);
    }
    
    [ServiceCallManager getUserWithObjectId:userId WithBlock:^(User *user, NSError *error) {
        if(!error){
            /**
            * Weiping, please use scannedUser object above to get all the user profile in the VC to be created here
            * Modal view is preferred here for the User Profile, if you agree with that.  Maybe CUFullProfileViewController can be reused here
            */
            
            [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
            
            CUFullProfileViewController *detailViewController = [[CUFullProfileViewController alloc] initWithNibName:@"CUFullProfileViewController" bundle:nil];
            detailViewController.person = user;
            [detailViewController addExitButton];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailViewController];
            
            [self presentViewController:nav
                               animated:YES
                             completion:NULL];
            
        } else {
            MyLog(@"Error = %@",error);
            [Common showAlertTitle:@"Error" msg:[error description] onView:self.view];
        }
    }];
    
    
    [reader dismissViewControllerAnimated:YES completion:nil];
}


@end
