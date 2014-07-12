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
#import "TWTSideMenuViewController/TWTSideMenuViewController.h"
#import "User.h"
#import "CUMemberViewController.h"
#import "CUEditProfileViewController.h"
#import "NSDateFormatter+Additions.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "MRProgress.h"

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
        NSLog(@"User b day:%@", user.birthday);
        self.phoneLabel.text    = [NSString stringWithFormat:@"%@", user.phone];
        self.wechatLabel.text   = [NSString stringWithFormat:@"%@", user.wechatID ? user.wechatID : @"Not linked to WeChat"];
        
        if (user.profilePic) {
            NSLog(@"User has profilePic!!");

            PFFile *profilePic = user.profilePic;

            [profilePic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error){
                if(!error)
                {
                    UIImage *proPic = [UIImage imageWithData:imageData];
                    NSLog(@"Successfully retrieved profilePic!");
                    self.profilePicView.image = proPic;
                }
            }];
        }
    } else {
        self.userNameLabel.text = NSLocalizedString(@"Not logged in", nil);
    }
    NSLog(@"emailVerified = %hhd", user.emailVerified);
    NSLog(@"objectId = %@", user.objectId);
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == self.actionSheet.destructiveButtonIndex) {
        [User logOut];
        [self.navigationController popViewControllerAnimated:YES];
        [self.sideMenuViewController closeMenuAnimated:YES completion:nil];
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
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    CUMemberViewController *controller = [[CUMemberViewController alloc] init];
    controller.profileVC = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
//    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

@end
