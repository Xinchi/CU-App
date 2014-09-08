//
//  OverlayManager.m
//  Chinese Union
//
//  Created by Max Gu on 9/8/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "Common.h"
#import "MRProgress.h"

@implementation Common
+ (void)dismissAllOverlayViewForView: (UIView *)view
{
    [MRProgressOverlayView dismissAllOverlaysForView:view animated:YES];
}

+ (void)showAlertTitle:(NSString *)title msg:(NSString *)msg onView:(UIView *)view {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [MRProgressOverlayView dismissAllOverlaysForView:view animated:YES];
}

+ (NSString *)getUsefulErrorMessage: (NSError *)error
{
    return [error userInfo][@"error]"];
}


@end
