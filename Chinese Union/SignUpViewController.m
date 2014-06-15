//
//  SignUpViewController.m
//  Chinese Union
//
//  Created by Max Gu on 6/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) UIEdgeInsets originalInsets;
@property (weak, nonatomic) UITextField *activeTextField;

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
    PFUser *user = [PFUser user];
    user.username = @"my name";
    user.password = @"my pass";
    user.email = @"email@example.com";
    
    // other fields can be set just like with PFObject
    user[@"phone"] = @"415-392-0202";
    user[@"wechat"] = @"";
    user[@"firstName"] = @"";
    user[@"lastName"] = @"";
    user[@"birthday"] = @"";
    user[@"memberID"] = @"";
    user[@""] = @"";
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
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
    newContentSize.height -= 180;
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
    }];
}

#pragma mark - Text Field

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"text change in range: %@, with string: %@", NSStringFromRange(range), string);

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
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}

- (IBAction)signUpButtonPressed:(id)sender {
    [self.activeTextField resignFirstResponder];
}

@end
