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
#import "CUNavigationController.h"
#import "Order.h"

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

static NSString* orderId;

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

- (UIStatusBarStyle)preferredStatusBarStyle
{
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
    CUNavigationController *nav = [[CUNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)memberButtonPressed:(id)sender {

    CUMemberViewController *controller = [[CUMemberViewController alloc] init];
    controller.profileViewController = self;
    CUNavigationController *nav = [[CUNavigationController alloc] initWithRootViewController:controller];
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
    CUNavigationController *nav = [[CUNavigationController alloc] initWithRootViewController:vc];
    [vc addExitButton];
    [self presentViewController:nav animated:YES completion:NULL];
}

#pragma mark - ZBarReaderDelegate

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    NSString *encryptedData;
    MyLog(@"Finished reading QR code...");
    //Handle the data read in
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    for(ZBarSymbol *symbol in results)
    {
        encryptedData = symbol.data;
        NSLog(@"FROM QR Scanning, encrypted data = %@",encryptedData);
    }
    
    NSArray *lines = [Common getDeliminatedString:encryptedData];
    
    if([[lines objectAtIndex:0] isEqualToString:@"user"])
    {
        NSString *userId = [lines objectAtIndex:1];
        MyLog(@"It's user QR code, and user id = %@", userId);
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
    } else if([[lines objectAtIndex:0] isEqualToString:@"order"]){
        User *user = [User currentUser];
        
        if(user.admin)
        {
            orderId = [lines objectAtIndex:1];
            MyLog(@"It's the order QR code, and the order id = %@", orderId);
            
            Order *order = [ServiceCallManager getOrderWithObjectId:orderId];
            UIAlertView *alert;
            NSString *msg = [NSString stringWithFormat:@"%@ \n %@", order.name, order.product];
            if(order != nil)
            {
                alert = [[UIAlertView alloc] initWithTitle:@"Check In For : "
                                                   message:msg
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Ok",nil];
                [alert show];
                [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
            } else {
                [Common showAlertTitle:@"Error" msg:[NSString stringWithFormat:@"Failed to get order with id %@",orderId] onView:self.view];
            }
        } else {
            [Common showAlertTitle:@"Error" msg:[NSString stringWithFormat:@"You don't have access to check people in"] onView:self.view];
        }
        
    } else {
        [Common showAlertTitle:@"Error" msg:[NSString stringWithFormat:@"Wrong QR Code"] onView:self.view];
    }
    
    [reader dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        return;
    }
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    if(buttonIndex == 1)
    {
        MyLog(@"Checking in starts for order id %@", orderId);
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:orderId, @"orderId", nil];
        [PFCloud callFunctionInBackground:@"checkIn" withParameters:dictionary block:^(NSString *result, NSError *error){
            if(!error){
                MyLog(@"No Error!");
                [Common showAlertTitle:@"Success!" msg:result onView:self.view];
            } else {
                MyLog(@"Error = %@",error);
                [Common showAlertTitle:@"Error" msg:[Common getUsefulErrorMessage:error] onView:self.view];
            }
        }];
    }
    
}


@end
