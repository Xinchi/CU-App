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

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UIImage *profilePic;

@end

@implementation ProfileViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    PFUser *user = [PFUser currentUser];
    if (user) {
        self.userNameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), [user username]];
//        self.realNameLabel.text = [NSString stringWithFormat:@"%@ %@", user.];
    } else {
        self.userNameLabel.text = NSLocalizedString(@"Not logged in", nil);
    }
}

#pragma mark - IBAction

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
    [self.sideMenuViewController closeMenuAnimated:YES completion:nil];
    
}


@end
