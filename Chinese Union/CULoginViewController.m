//
//  CULoginViewController.m
//  Chinese Union
//
//  Created by wpliao on 2014/6/14.
//  Copyright (c) 2014年 ucsd.ChineseUnion. All rights reserved.
//

#import "CULoginViewController.h"
#import "SignUpViewController.h"
#import "User.h"
#import "UIViewController+Additions.h"
#import "MBProgressHUD.h"
#import "MRProgress.h"
#import "CUForgotPasswordViewController.h"
#import "User.h"
#import "ServiceCallManager.h"

@interface CULoginViewController ()

@property (weak, nonatomic) UIResponder *activeResponder;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGR;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation CULoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Login";

    [self addExitButton];
    
    [self.view addGestureRecognizer:self.tapGR];
    
    self.userNameTextField.layer.opacity = 0.9;
    self.passwordTextField.layer.opacity = 0.9;
    
    [self addBorderToButton:self.fbButton];
    [self addBorderToButton:self.twitterButton];
    [self addBorderToButton:self.signupButton];
    [self addBorderToButton:self.forgotPasswordButton];
    
//    RAC(self.loginButton, enabled) = [RACSignal
//                                      combineLatest:@[self.userNameTextField.rac_textSignal,
//                                                      self.passwordTextField.rac_textSignal]
//                                                       reduce:^(NSString *username, NSString *password){
//                                                           return @(username.length > 0 && password.length > 0);
//    }];
}

- (IBAction)signUpButtonPressed:(id)sender {
    SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signUpVC];
    signUpVC.delegate = self.delegate;
    MyLog(@"Delegate:%@", signUpVC.delegate);
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)loginButtonPressed:(id)sender {
    [self.activeResponder resignFirstResponder];
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    [ServiceCallManager logInWithUsernameInBackground:self.userNameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error){
        if(error) {
            [self loginFailedWithError:error];
        }
        else {
            [self loginSucceeded];
        }
    }];
}

- (void) loginFailedWithError: (NSError *)error
{
    [ServiceCallManager callFunctionInBackground:@"loginFail" withParameters:@{} block:^(NSString *result, NSError *error){
        if(!error){
            [self showAlertTitle:NSLocalizedString(@"Error", @"")
                             msg:result];
        }
    }];
}
- (void) loginSucceeded
{
    MyLog(@"Login Succeeded!");
    [ServiceCallManager callFunctionInBackground:@"loginSuccessful" withParameters:@{} block:^(NSString *result, NSError *error){
        if(!error){
            [self showAlertTitle:NSLocalizedString(@"Success!", @"")
                             msg:result];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)viewTapped:(id)sender {
    [self.activeResponder resignFirstResponder];
}

#pragma mark - Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeResponder = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self loginButtonPressed:nil];
    }
    return YES;
}

- (void)showAlertTitle:(NSString *)title msg:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
}

#pragma mark - IBActions

- (IBAction)forgotPasswordButtonPressed:(UIButton *)sender {
    CUForgotPasswordViewController *vc = [[CUForgotPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)fbButtonPressed:(UIButton *)sender {
    BOOL syncFromFBAllowedByUser = YES;
//    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Logging in..." mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    MyLog(@"FB button!");
    
    NSArray *permissions = [NSArray arrayWithObjects:@"public_profile",@"email", @"user_birthday",nil];
    
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if(error){
            MyLog(@"Error: %@",error);
        }
        if (!user) {
            MyLog(@"Uh oh. The user cancelled the Facebook login.");
            [self showAlertTitle:@"Login fail" msg:@"Please check Settings->Facebook and make sure the the toggle for Chinese Union is on"];
        } else {
            
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Success! Include your code to handle the results here
                    NSDictionary *userInfo = result;
                    NSLog(@"user info: %@", [userInfo description]);
                    //
                    if(syncFromFBAllowedByUser)
                    {
                        [self updateUserWithDictionary:result withUser:user newUser:user.isNew];
                    }
                    else
                    {
                        [self showAlertTitle:@"Welcome back!" msg:@"Info not synced from facebook!"];
                    }
                    
                } else {
                    MyLog(@"### ERROR: %@",error);
                    // An error occurred, we need to handle the error
                    // See: https://developers.facebook.com/docs/ios/errors
                }
            }];
            
            // Check for publish permissions
            [FBRequestConnection startWithGraphPath:@"/me/permissions"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error){
                                          NSDictionary *permissions= result;
                                          MyLog(@"permissions = %@",permissions);
                                      } else {
                                          // There was an error, handle it
                                          // See https://developers.facebook.com/docs/ios/errors/
                                      }
                                  }];
            
            
        }
    }];
    
    
    
}

- (void) updateUserWithDictionary:(NSDictionary *)userInfo withUser: (PFUser *)user newUser:(BOOL)isNewUser
{
    User *currentUser = (User *)user;
//    currentUser.objectId = userInfo[@"email"];
//    currentUser.username = userInfo[@"first_name"];
    currentUser.firstName = userInfo[@"first_name"];
    currentUser.lastName = userInfo[@"last_name"];
    currentUser.email = userInfo[@"email"];
    currentUser.gender = userInfo[@"gender"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    MyLog(@"User birthday = %@",userInfo[@"birthday"]);
    currentUser.birthday = [formatter dateFromString:userInfo[@"birthday"]];
    MyLog(@"curretUser.birthday = %@",currentUser.birthday);
    MyLog(@"formatter NSDate = %@",[formatter dateFromString:userInfo[@"birthday"]]);
    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", userInfo[@"id"]]];
    NSData *imageData = [NSData dataWithContentsOfURL:pictureURL];
    PFFile *imageFile = [PFFile fileWithData:imageData];
    currentUser.profilePic = imageFile;
    
    [ServiceCallManager updateUserInfoWithUser:currentUser WithBlock:^(BOOL succeeded, NSError *error){
       if(!error)
       {
           [self dismissViewControllerAnimated:YES completion:nil];

           if(isNewUser)
           {
               MyLog(@"Save new fb user successfully!");
               [self showAlertTitle:@"Welcome!" msg:@"New facebook user successfully registered, welcome to Chinese Union!"];
           }
           else
           {
               MyLog(@"Old fb user logged in!");
               [self showAlertTitle:@"Welcome back!" msg:@"Good to see you again!"];
           }
           
       }
       else{
           MyLog(@"Error !!! : %@",error);

           
           [self showAlertTitle:@"Opps" msg:[error userInfo][@"error"]];
       }
    }];
}

- (IBAction)twitterButtonPressed:(UIButton *)sender {
    MyLog(@"Twitter button!");
}

@end
