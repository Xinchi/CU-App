//
//  CULoginViewController.m
//  Chinese Union
//
//  Created by wpliao on 2014/6/14.
//  Copyright (c) 2014年 ucsd.ChineseUnion. All rights reserved.
//

#import "CULoginViewController.h"
#import "SignUpViewController.h"

@interface CULoginViewController ()

@end

@implementation CULoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Login";
    UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStyleBordered target:self action:@selector(exitButtonPressed)];
    self.navigationItem.leftBarButtonItem = exitButton;
}

- (void)exitButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)signUpButtonPressed:(id)sender {
    SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signUpVC];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
