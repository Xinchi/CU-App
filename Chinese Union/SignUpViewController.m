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
#import "CUInputButton.h"
#import "UIViewController+Additions.h"
#import "NSDateFormatter+Additions.h"
#import "SLGlowingTextField.h"

@interface SLGlowingTextField (Valid)

- (void)inValidate;
- (void)validate;
- (BOOL)validLength;
- (BOOL)validString:(NSString *)string;
- (BOOL)validEmailFormat;
- (BOOL)checkCondition:(BOOL)condition;

@end

@implementation SLGlowingTextField (Valid)

- (void)inValidate {
    self.alwaysGlowing = YES;
    self.glowingColor = [UIColor colorWithRed:1.000 green:0.180 blue:0.097 alpha:1.000];
}

- (void)validate {
    self.alwaysGlowing = NO;
    self.glowingColor = [UIColor colorWithRed:(82.f / 255.f) green:(168.f / 255.f) blue:(236.f / 255.f) alpha:0.8];
}

- (BOOL)validLength {
    return [self checkCondition:[self.text cleanString].length > 0];
}

- (BOOL)validString:(NSString *)string {
    return [self checkCondition:[self.text isEqualToString:string]];
}

- (BOOL)validEmailFormat {
    return [self checkCondition:[self.text isEmailFormat]];
}

- (BOOL)checkCondition:(BOOL)condition {
    if (!condition) {
        [self inValidate];
    }
    else {
        [self validate];
    }
    return condition;
}

@end

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) UIEdgeInsets originalInsets;
@property (weak, nonatomic) UIResponder *activeResponder;
@property (weak, nonatomic) IBOutlet SLGlowingTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet SLGlowingTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet SLGlowingTextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet SLGlowingTextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet SLGlowingTextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet SLGlowingTextField *emailTextField;
@property (weak, nonatomic) IBOutlet SLGlowingTextField *confirmEmailTextField;
@property (weak, nonatomic) IBOutlet SLGlowingTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet SLGlowingTextField *weChatTextField;
@property (weak, nonatomic) IBOutlet CUInputButton *pickBirthdayButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGR;

@property (strong, nonatomic) NSArray *textFields;

@property (strong, nonatomic) NSDate *birthday;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Sign Up";    

    [self addExitButton];
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(signUpButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = submitButton;
    NSLog(@"ScrollView content size:%@", NSStringFromCGSize(self.scrollView.contentSize));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.datePicker.maximumDate = [NSDate date];
    self.pickBirthdayButton.inputView = self.datePicker;
    
    [self.view addGestureRecognizer:self.tapGR];
    
    [self addBorderToButton:self.pickBirthdayButton];
    
    self.textFields = @[self.userNameTextField,
                        self.passwordTextField,
                        self.confirmPasswordTextField,
                        self.firstNameTextField,
                        self.lastNameTextField,
                        self.emailTextField,
                        self.confirmEmailTextField,
                        self.phoneTextField,
                        self.weChatTextField];
    
    float opacity = 0.9;
    for (SLGlowingTextField *textfield in self.textFields) {
        textfield.layer.opacity = opacity;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    user.birthday = self.datePicker.date;
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

#pragma mark - IBActions

- (IBAction)pickBirthdayButtonPressed:(CUInputButton *)sender {
    [sender becomeFirstResponder];
    self.activeResponder = sender;
}

- (IBAction)dateValueChanged:(UIDatePicker *)sender {
    NSString *title = [[NSDateFormatter birthdayFormatter] stringFromDate:sender.date];
    [self.pickBirthdayButton setTitle:title forState:UIControlStateNormal];
    self.birthday = sender.date;
}

- (IBAction)viewTapped:(UITapGestureRecognizer *)sender {
    [self.activeResponder resignFirstResponder];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UITextField *nextTextField = [self nextTextField:textField];
    [nextTextField becomeFirstResponder];

    if (nextTextField == nil) {
        [self.activeResponder resignFirstResponder];
    }
    
    return YES;
}

- (UITextField *)nextTextField:(UITextField *)textField {
    NSUInteger index = [self.textFields indexOfObject:textField];
    NSUInteger nextIndex = index + 1;
    if (nextIndex >= [self.textFields count]) {
        return nil;
    }
    
    return self.textFields[nextIndex];
}

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
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeResponder = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"TextField:%@ did end editing", textField);
    textField.text = [textField.text cleanString];
    [self validateTextField:textField];
}

- (NSString *)validateTextField:(SLGlowingTextField *)textField {
    if (textField == self.userNameTextField) {
        if (![textField validLength]) {
            return NSLocalizedString(@"Please fill in user name", @"");
        }
    }
    
    if (textField == self.passwordTextField) {
        if (![textField validLength]) {
            return NSLocalizedString(@"Please fill in password", @"");
        }
    }
    
    if (textField == self.confirmPasswordTextField) {
        if (![textField validString:self.passwordTextField.text]) {
            return NSLocalizedString(@"Passwords are not the same", @"");
        }
    }

    if (textField == self.firstNameTextField) {
        if (![textField validLength]) {
            return NSLocalizedString(@"Please fill in first name", @"");
        }
    }
    
    if (textField == self.lastNameTextField) {
        if (![textField validLength]) {
            return NSLocalizedString(@"Please fill in last name", @"");
        }
    }
    
    if (textField == self.emailTextField) {
        if (![textField validEmailFormat]) {
            return NSLocalizedString(@"Wrong email format", @"");
        }
    }
    
    if (textField == self.confirmEmailTextField) {
        if (![textField validString:self.emailTextField.text]) {
            return NSLocalizedString(@"Email addresses are not the same", @"");
        }
    }
    
    if (textField == self.phoneTextField) {
        if (![textField validLength]) {
            return NSLocalizedString(@"Please fill in phone number", @"");
        }
    }
    
    if (textField == self.weChatTextField) {
        if (![textField validLength]) {
            return NSLocalizedString(@"Please fill in WeChat ID", @"");
        }
    }
    
    return nil;
}

- (NSString *)validateInputs {
    NSMutableArray *errorMsgs = [NSMutableArray array];
    
    for (SLGlowingTextField *textfield in self.textFields) {
        NSString *err = [self validateTextField:textfield];
        if (err) {
            [errorMsgs addObject:err];
        }
    }
    
    return [errorMsgs componentsJoinedByString:@"\n"];
}

//- (NSString *)validateInputs {
//    NSMutableArray *errorMsgs = [NSMutableArray array];
//    
//    if (!self.userNameTextField.text.length > 0) {
//        [errorMsgs addObject:@"Please fill in user name"];
//    }
//    
//    if (!self.passwordTextField.text.length > 0) {
//        [errorMsgs addObject:@"Please fill in password"];
//    }
//    
//    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
//        [errorMsgs addObject:@"Passwords are not the same"];
//    }
//    
//    if (![self.firstNameTextField.text cleanString].length > 0) {
//        [errorMsgs addObject:@"Please fill in first name"];
//    }
//    
//    if (![self.lastNameTextField.text cleanString].length > 0) {
//        [errorMsgs addObject:@"Please fill in last name"];
//    }
//    
//    BOOL emailValid = [self.emailTextField.text isEmailFormat];
//    
//    if (!emailValid) {
//        [errorMsgs addObject:@"Wrong email format"];
//    }
//    
//    if (![self.emailTextField.text isEqualToString:self.confirmEmailTextField.text]) {
//        [errorMsgs addObject:@"EMail addresses are not the same"];
//    }
//    
//    if (!self.phoneTextField.text.length > 0) {
//        [errorMsgs addObject:@"Please fill in phone number"];
//    }
//    
//    if (!self.weChatTextField.text.length > 0) {
//        [errorMsgs addObject:@"Please fill in WeChat ID"];
//    }
//    
//    if (!self.birthday) {
//        [errorMsgs addObject:@"Please pick your birthday"];
//    }
//    
//    return [errorMsgs componentsJoinedByString:@"\n"];
//}

- (IBAction)signUpButtonPressed:(id)sender {
    [self.activeResponder resignFirstResponder];
    
    NSString *errorMsgs = [self validateInputs];
    
    if (errorMsgs.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:errorMsgs
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self doSignup];
}

@end
