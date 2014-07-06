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

@interface CUEditProfileTextViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation CUEditProfileTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textField.text = self.text;
    [self addSaveButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)saveButtonPressed {
    [self.textField resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    switch (self.option) {
        case CUProfileEditFirstName:
            break;
            
        case CUProfileEditLastName:
            break;
            
        case CUProfileEditEmail:
            break;
            
        case CUProfileEditPhone:
            break;
            
        case CUProfileEditWeChat:
            break;
            
        default:
            break;
    }
}

@end
