//
//  CUForgotPasswordViewController.m
//  Chinese Union
//
//  Created by wpliao on 7/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUForgotPasswordViewController.h"
#import "SLGlowingTextField.h"

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
    NSString *username = self.usernameTextField.text;
}

@end
