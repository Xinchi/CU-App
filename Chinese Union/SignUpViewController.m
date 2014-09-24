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
#import "MBProgressHUD.h"
#import "MRProgress.h"
#import "CUProfileEditOption.h"
#import "SLGlowingTextField+Valid.h"
#import "ServiceCallManager.h"

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
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGR;
@property (weak, nonatomic) IBOutlet UIView *contentView;

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
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.navigationItem.rightBarButtonItem = submitButton;
    
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

//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view animated:YES];
    User *user = (User *)[User user];
    
    user.username = self.userNameTextField.text;
    user.password = self.passwordTextField.text;
    user.firstName = self.firstNameTextField.text;
    user.lastName = self.lastNameTextField.text;
    user.email = self.emailTextField.text;
    user.phone = self.phoneTextField.text;
    user.wechatID = self.weChatTextField.text;
    user.birthday = self.birthday;
    if(self.segmentControl.selectedSegmentIndex==0)
        user.gender = kMale;
    else
        user.gender = kFemale;

    [ServiceCallManager signUpInBackgroundWithUser:user WithBlock:^(BOOL succeeded, NSError *error) {
        if(!error) {
            [ServiceCallManager callFunctionInBackground:CloudFunctionSignupSuccess withParameters:@{} block:^(NSString *result, NSError *error){
                if(!error){
                    [self showAlertTitle:NSLocalizedString(@"Success!", @"")
                                     msg:result];
                }
                else {
                    [self showAlertTitle:NSLocalizedString(@"Success!", @"")
                                     msg:@"Signup successfull! Caution: parseNotificationCall failed, please contact Max Gu (xig015@eng.ucsd.edu) immediately for this issue"];
                }
            }];
            [self.delegate signUpViewController:self didSignUpUser:user];

        }
        else {
            NSLog(@"Hey weiping, the error message needs to be printed out is : %@",[error userInfo][@"error"]);
        }
    }];
}

#pragma mark - IBActions

- (IBAction)pickBirthdayButtonPressed:(CUInputButton *)sender {
    [sender becomeFirstResponder];
    MyLog(@"Input view: %@", sender.inputView);
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
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentInset = contentInset;
        self.scrollView.scrollIndicatorInsets = contentInset;
    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentInset = self.originalInsets;
        self.scrollView.scrollIndicatorInsets = self.originalInsets;
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

    if (textField == self.userNameTextField /*||
        textField == self.passwordTextField ||
        textField == self.confirmPasswordTextField*/) {
        BOOL valid = [string isAlphaNumeric];
        
        if (!valid) {
            [self showAlertTitle: NSLocalizedString(@"Error", @"") msg:[NSString stringWithFormat:@"Cannot contain %@", string]];
        }
        
        return valid;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeResponder = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = [textField.text cleanString];
    [self validateTextField:(SLGlowingTextField *)textField];
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
    
    if (self.birthday == nil) {
        [errorMsgs addObject:NSLocalizedString(@"Please pick a birthday", @"")];
    }
    
    return [errorMsgs componentsJoinedByString:@"\n"];
}

- (IBAction)signUpButtonPressed:(id)sender {
    [self.activeResponder resignFirstResponder];
    
    NSString *errorMsgs = [self validateInputs];
    
    if (errorMsgs.length > 0) {

        [self showAlertTitle: NSLocalizedString(@"Error", @"") msg:errorMsgs];
        return;
    }
    
    [self doSignup];
}

- (void)showAlertTitle:(NSString *)title msg:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

    [MRProgressOverlayView dismissAllOverlaysForView:self.navigationController.view animated:YES];
}

@end
