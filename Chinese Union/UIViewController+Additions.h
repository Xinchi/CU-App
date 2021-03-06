//
//  UIViewController+Additions.h
//  Chinese Union
//
//  Created by wpliao on 6/29/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)

- (void)addExitButton;
- (void)exitButtonPressed;
- (void)addSaveButton;
- (void)saveButtonPressed;
- (void)addBorderToButton:(UIButton *)button;

@end
