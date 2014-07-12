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

@interface CUEditProfileTextViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation CUEditProfileTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textField.text = self.text;
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
    
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];

    User *user = [User currentUser];
    
    switch (self.option) {
        case CUProfileEditFirstName:
            NSLog(@"Editing first name");
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
            
        default:
            break;
    }
    
    [user save];
    
//    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:true];
    
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", @"")                                                      message:NSLocalizedString(@"Updated successfully!", @"")
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
//                                          otherButtonTitles: nil];
//    [message show];
    
    [self.navigationController popViewControllerAnimated:YES];
//    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:true];
//    [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success"
//                                                      message:@"Updated successfully!"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles: nil];
//    [message show];
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
