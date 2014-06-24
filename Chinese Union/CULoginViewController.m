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

@interface CULoginViewController ()

@property (weak, nonatomic) UIResponder *activeResponder;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGR;

@end

@implementation CULoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Login";
    UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Line + Line 2"] style:UIBarButtonItemStyleBordered target:self action:@selector(exitButtonPressed)];
//    UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStyleBordered target:self action:@selector(exitButtonPressed)];
    self.navigationItem.leftBarButtonItem = exitButton;
    
    [self.view addGestureRecognizer:self.tapGR];
}

- (void)exitButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signUpButtonPressed:(id)sender {
    SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signUpVC];
    signUpVC.delegate = self.delegate;
    NSLog(@"Delegate:%@", signUpVC.delegate);
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)loginButtonPressed:(id)sender {
    NSError *error;
    [User logInWithUsername:self.userNameTextField.text
                   password:self.passwordTextField.text
                      error:&error];
    
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error userInfo][@"error"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else {
        NSLog(@"Login Succeeded!");
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

@end
