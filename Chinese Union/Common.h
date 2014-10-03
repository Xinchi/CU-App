//
//  OverlayManager.h
//  Chinese Union
//
//  Created by Max Gu on 9/8/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Common : NSObject

+ (void)dismissAllOverlayViewForView: (UIView *)view;

+ (void)showAlertTitle:(NSString *)title msg:(NSString *)msg onView:(UIView *)view;

+ (NSString *)getUsefulErrorMessage: (NSError *)error;

+ (UIImage *)generateQRCodeWithData: (NSString *)data withSize:(CGFloat)size withFillColor: (UIColor *)fillColor;


@end
