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

@interface CULoginViewController ()

@property (weak, nonatomic) UIResponder *activeResponder;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGR;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

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
}

- (IBAction)signUpButtonPressed:(id)sender {
    SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signUpVC];
    signUpVC.delegate = self.delegate;
    NSLog(@"Delegate:%@", signUpVC.delegate);
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)loginButtonPressed:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSError *error;
    //show MB
    
    NSLog(@"Button Pressed!");
    
    [User logInWithUsername:self.userNameTextField.text
                   password:self.passwordTextField.text
                      error:&error];
    
    if (error) {
        [PFCloud callFunctionInBackground:@"loginFail" withParameters:@{} block:^(NSString *result, NSError *error){
            if(!error){
                [self showAlertTitle:NSLocalizedString(@"Error", @"")
                                 msg:result];
            }
        }];
    }
    else {
        NSLog(@"Login Succeeded!");
        [PFCloud callFunctionInBackground:@"loginSuccessful" withParameters:@{} block:^(NSString *result, NSError *error){
            if(!error){
                [self showAlertTitle:NSLocalizedString(@"Success!", @"")
                                 msg:result];
            }
        }];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
