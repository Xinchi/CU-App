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

@interface CULoginViewController ()

@property (weak, nonatomic) UIResponder *activeResponder;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGR;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;

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

//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    NSError *error;
    
    MyLog(@"Button Pressed!");
    
    [User logInWithUsername:self.userNameTextField.text
                   password:self.passwordTextField.text
                      error:&error];
    
    if (error) {
        [self loginFailedWithError:error];
    }
    else {
        [self loginSucceeded];
    }
}

- (void) loginFailedWithError: (NSError *)error
{
    [PFCloud callFunctionInBackground:@"loginFail" withParameters:@{} block:^(NSString *result, NSError *error){
        if(!error){
            [self showAlertTitle:NSLocalizedString(@"Error", @"")
                             msg:result];
        }
    }];
}
- (void) loginSucceeded
{
    MyLog(@"Login Succeeded!");
    [PFCloud callFunctionInBackground:@"loginSuccessful" withParameters:@{} block:^(NSString *result, NSError *error){
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
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    MyLog(@"FB button!");
    
    NSArray *permissions = [NSArray arrayWithObjects:@"public_profile",@"email", @"user_birthday",nil];
    
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if(error){
            MyLog(@"Error: %@",error);
        }
        if (!user) {
            MyLog(@"Uh oh. The user cancelled the Facebook login.");
            [self showAlertTitle:@"Uh oh" msg:@"Login has been canceled"];
        } else if (user.isNew) {
            MyLog(@"User signed up and logged in through Facebook!");
            //handle new user case
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Success! Include your code to handle the results here
                    NSDictionary *userInfo = result;
                    NSLog(@"user info: %@", [userInfo description]);
                    //update user info
                    [self createNewUserWithDictionary:result withUser:user];
                } else {
                    // An error occurred, we need to handle the error
                    // See: https://developers.facebook.com/docs/ios/errors
                }
            }];
        } else {
            MyLog(@"User logged in through Facebook!");
            [self loginSucceeded];
            NSDictionary *params = [NSDictionary dictionaryWithObject:@"picture.type(large)" forKey:@"fields"];
            
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:params
                                         HTTPMethod:@"GET"
                                  completionHandler:^(
                                                      FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error
                                                      ) {
                                      /* handle the result */
                                      if(error)
                                      {
                                          NSLog(@"Error in loading profile pic : %@",error);
                                      }
                                      MyLog(@"picture = %@", result);
                                      NSURL *imageURL = [NSURL URLWithString:result];
                                      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                                      PFFile *imageFile = [PFFile fileWithData:imageData];
                                      User *user = [User currentUser];
                                      user.profilePic = imageFile;
                                      [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                                          if(!error)
                                          {
                                              [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
                                          }
                                      }];
                                  }];
        }
    }];
    
    
    
}

- (void) createNewUserWithDictionary:(NSDictionary *)userInfo withUser: (PFUser *)user
{
    User *currentUser = (User *)user;
//    currentUser.objectId = userInfo[@"email"];
    currentUser.username = userInfo[@"email"];
    currentUser.firstName = userInfo[@"first_name"];
    currentUser.lastName = userInfo[@"last_name"];
    currentUser.email = userInfo[@"email"];
    currentUser.gender = userInfo[@"gender"];
    NSDateFormatter *formatter;
    [formatter setDateFormat:@"MM'/'dd'/'yyyy"];
    currentUser.birthday = [formatter dateFromString:userInfo[@"birthday"]];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
       if(!error)
       {
           MyLog(@"Save new fb user successfully!");
       }
       else{
           MyLog(@"Error !!! : %@",error);
       }
    }];
}

- (IBAction)twitterButtonPressed:(UIButton *)sender {
    MyLog(@"Twitter button!");
}

@end
