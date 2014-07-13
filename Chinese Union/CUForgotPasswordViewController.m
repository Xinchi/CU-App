//
//  CUForgotPasswordViewController.m
//  Chinese Union
//
//  Created by wpliao on 7/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUForgotPasswordViewController.h"
#import "SLGlowingTextField.h"
#import "User.h"
#import "MRProgress.h"

@interface CUForgotPasswordViewController ()
@property (weak, nonatomic) IBOutlet SLGlowingTextField *usernameTextField;

@end

@implementation CUForgotPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Retrieve password";
}

- (IBAction)retreivePasswordButtonPressed:(id)sender {
    [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    NSString *email = self.usernameTextField.text;
    PFQuery *query = [User query];
    [query whereKey:@"email" equalTo:email];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       if(!error && [objects count]==1)
       {
           [User requestPasswordResetForEmail:email];
           [PFCloud callFunctionInBackground:@"correctEmailForResettingPassword" withParameters:@{} block:^(NSString *result, NSError *error){
               if(!error){
                   [self showAlertTitle:NSLocalizedString(@"Success!", @"")
                                    msg:result];
               }
           }];

           [self.navigationController popViewControllerAnimated:YES];
       }
       else{
           //popping out error message
           [PFCloud callFunctionInBackground:@"incorrectEmailForResettingPassword" withParameters:@{} block:^(NSString *result, NSError *error){
               if(!error){
                   [self showAlertTitle:NSLocalizedString(@"Error", @"")
                                    msg:result];
               }
           }];
       }
        
    }];
    
}

- (void)showAlertTitle:(NSString *)title msg:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
}

@end
