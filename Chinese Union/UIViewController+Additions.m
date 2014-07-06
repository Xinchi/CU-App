//
//  UIViewController+Additions.m
//  Chinese Union
//
//  Created by wpliao on 6/29/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "UIViewController+Additions.h"
#import "MBProgressHUD.h"

@implementation UIViewController (Additions)

- (void)addExitButton {
    UIBarButtonItem *exitButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Line + Line 2"] style:UIBarButtonItemStyleBordered target:self action:@selector(exitButtonPressed)];
    self.navigationItem.leftBarButtonItem = exitButton;
}

- (void)exitButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addSaveButton {
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)addBorderToButton:(UIButton *)button {
    button.layer.cornerRadius = 12;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor whiteColor] CGColor];
}

@end
