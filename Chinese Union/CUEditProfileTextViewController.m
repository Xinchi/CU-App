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
#import "ServiceCallManager.h"
#import "Common.h"

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
        [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view animated:YES];
        BOOL valid = [self validateInputs];
        if (valid) {
            user.password = self.changePasswordTF.text;
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded) {
                    [Common showAlertTitle:@"Success" msg:@"Password has been changed successfully!" onView:self.navigationController.view];
                } else {
                    [Common showAlertTitle:@"Error" msg:[Common getUsefulErrorMessage:error] onView:self.navigationController.view];
                }
            }];
        }
        else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
//                                                            message:NSLocalizedString(@"Incorrect password", @"")
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
            MyLog(@"Password change unsuccessful");
            return;
        }
    }
    
    [user save];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validateInputs {
    if ([ServiceCallManager VerifyPasswordWithPassword:self.textField.text])
    {
        // Password is valid
        if (![self.changePasswordTF.text isEqualToString:self.confirmNewPasswordTF.text]) {
            [Common showAlertTitle:@"Error" msg:@"The 2 passwords don't match" onView:self.navigationController.view];
            return NO;
        }
    } else {
        // Password is not valid
        [Common dismissAllOverlayViewForView:self.navigationController.view];
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
