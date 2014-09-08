//
//  OverlayManager.m
//  Chinese Union
//
//  Created by Max Gu on 9/8/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "OverlayManager.h"
#import "MRProgress.h"

@implementation OverlayManager
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


@end
