//
//  CUEditProfileTextViewController.m
//  Chinese Union
//
//  Created by wpliao on 6/29/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUEditProfileTextViewController.h"
#import "UIViewController+Additions.h"
#import "MBProgressHUD.h"
#import "User.h"
#import "NSString+Additions.h"
#import "MRProgress.h"
#import "SLGlowingTextField.h"

@interface CUEditProfileTextViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *changePasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPasswordTF;

- (BOOL)validateInputs;

@end

@implementation CUEditProfileTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.option != CUProfileEditPassword) {
        self.textField.text = self.text;
    }
    else {
        self.textField.placeholder = NSLocalizedString(@"Enter old password", @"");
        self.changePasswordTF.placeholder = NSLocalizedString(@"Enter new password", @"");
        self.confirmNewPasswordTF.placeholder = NSLocalizedString(@"Confirm your password", @"");
        
        self.changePasswordTF.hidden = NO;
        self.confirmNewPasswordTF.hidden = NO;
        
        self.textField.secureTextEntry = YES;
        self.changePasswordTF.secureTextEntry = YES;
        self.confirmNewPasswordTF.secureTextEntry = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)saveButtonPressed {

    [self.textField resignFirstResponder];
    
    if (![self isValidInput]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")                                                      message:NSLocalizedString(@"Wrong format!", @"")
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                otherButtonTitles: nil];
        [message show];
        return;
    }

    User *user = [User currentUser];
    
    switch (self.option) {
        case CUProfileEditFirstName:
            MyLog(@"Editing first name");
            user.firstName = self.textField.text;
            break;
            
        case CUProfileEditLastName:
            user.lastName = self.textField.text;
            break;
            
        case CUProfileEditEmail:
            user.email = self.textField.text;
            break;
            
        case CUProfileEditPhone:
            user.phone = self.textField.text;
            break;
            
        case CUProfileEditWeChat:
            user.wechatID = self.textField.text;
            break;
            
//        case CUProfileEditPassword:
//            BOOL valid = [self ]
//            user.password = self.textField.text;
//            break;
            
        default:
            break;
    }
    
    if (self.option == CUProfileEditPassword) {
        BOOL valid = [self validateInputs];
        if (valid) {
            user.password = self.changePasswordTF.text;
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                                            message:NSLocalizedString(@"Incorrect password", @"")
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    [user save];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validateInputs {
    User *user = [User currentUser];
    
    if (![self.textField.text isEqualToString:user.password]) {
        MyLog(@"Password is %@", user.password);
        return NO;
    }

    if (![self.changePasswordTF.text isEqualToString:self.confirmNewPasswordTF.text]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isValidInput {
    BOOL result = NO;
    
    result = ![self.textField.text hasNoContent];
    
    if (self.option == CUProfileEditEmail) {
        result = [self.textField.text isEmailFormat];
    }
    
    return result;
}

@end
