//
//  SignUpViewController.m
//  Chinese Union
//
//  Created by Max Gu on 6/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "SignUpViewController.h"
#import "NSString+Additions.h"
#import "User.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) UIEdgeInsets originalInsets;
@property (weak, nonatomic) UITextField *activeTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *weChatTextField;
@property (strong, nonatomic) NSDate *birthday;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Sign Up";
    UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStyleBordered target:self action:@selector(exitButtonPressed)];
    self.navigationItem.leftBarButtonItem = exitButton;
    NSLog(@"ScrollView content size:%@", NSStringFromCGSize(self.scrollView.contentSize));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)exitButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doSignup {

    User *user = (User *)[User user];

    
    user.username = self.userNameTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    
    // other fields can be set just like with PFObject
    user.phone = self.phoneTextField.text;
    user.wechatID = self.weChatTextField.text;
    user.firstName = self.firstNameTextField.text;
    user.lastName = self.lastNameTextField.text;
    user.birthday = [NSDate date];
//    user[@"memberID"] = @"";
//    user[@""] = @"";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            if (succeeded) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succeed"
                                                                message:@"Sign up succeeded! Enjoy the app"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                [self.delegate signUpViewController:self didSignUpUser:user];
            }
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:errorString
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }];
}

#pragma mark - Keyboard Events

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];

    UIEdgeInsets contentInset = self.scrollView.contentInset;
    self.originalInsets = contentInset;
    contentInset.bottom = keyboardRect.size.height;
    self.scrollView.contentInset = contentInset;
    self.scrollView.scrollIndicatorInsets = contentInset;
    CGSize newContentSize = self.scrollView.frame.size;
//    newContentSize.height -= 50;
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentSize = newContentSize;
    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentInset = self.originalInsets;
        self.scrollView.scrollIndicatorInsets = self.originalInsets;
        self.scrollView.contentSize = CGSizeZero;
    }];
}

#pragma mark - Text Field

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"text change in range: %@, with string: %@", NSStringFromRange(range), string);

    if (textField == self.userNameTextField ||
        textField == self.passwordTextField ||
        textField == self.confirmPasswordTextField) {
        BOOL valid = [string isAlphaNumeric];
        
        if (!valid) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Cannot contain %@", string] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
        return valid;
    }
    
    return YES;
    
//    if (YES) {
//        NSLog(@"text change in range: %@, with string: %@", NSStringFromRange(range), string);
//        NSLog(@"current string length: %d", textField.text.length);
//        
//        if ([string isAllDigits]) {
//            return YES;
//        }
//        else if ([string isEqualToString:@" "] && range.length > 0) {
//            // The character is space, but the action is deleting, thus return YES
//            return YES;
//        }
//        else {
//            return NO;
//        }
//    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = [textField.text cleanString];
}

- (IBAction)signUpButtonPressed:(id)sender {
    [self.activeTextField resignFirstResponder];
    
    NSMutableArray *errorMsgs = [NSMutableArray array];
    
    if (!self.userNameTextField.text.length > 0) {
        [errorMsgs addObject:@"Please fill in user name"];
    }
    
    if (!self.passwordTextField.text.length > 0) {
        [errorMsgs addObject:@"Please fill in password"];
    }
    
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [errorMsgs addObject:@"Passwords are not the same"];
    }
    
    if (![self.firstNameTextField.text cleanString].length > 0) {
        [errorMsgs addObject:@"Please fill in first name"];
    }
    
    if (![self.lastNameTextField.text cleanString].length > 0) {
        [errorMsgs addObject:@"Please fill in last name"];
    }
    
    BOOL emailValid = [self.emailTextField.text isEmailFormat];
    
    if (!emailValid) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong Email Format" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        [errorMsgs addObject:@"Wrong email format"];
    }

    if (![self.emailTextField.text isEqualToString:self.confirmEmailTextField.text]) {
        [errorMsgs addObject:@"EMail addresses are not the same"];
    }
    
    if (!self.phoneTextField.text.length > 0) {
        [errorMsgs addObject:@"Please fill in phone number"];
    }
    
    if (!self.weChatTextField.text.length > 0) {
        [errorMsgs addObject:@"Please fill in WeChat ID"];
    }
    
    if (errorMsgs.count > 0) {
        NSString *message = [errorMsgs componentsJoinedByString:@"\n"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self doSignup];
}

@end
