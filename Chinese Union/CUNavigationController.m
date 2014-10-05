//
//  CUNavigationController.m
//  Chinese Union
//
//  Created by wpliao on 10/4/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUNavigationController.h"

@implementation CUNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIStatusBarStyle style = UIStatusBarStyleLightContent;
//    if (self.topViewController) {
//        style = [self.topViewController preferredStatusBarStyle];
//    }
    return style;
}

@end
