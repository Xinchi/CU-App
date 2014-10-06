//
//  OverlayManager.m
//  Chinese Union
//
//  Created by Max Gu on 9/8/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "Common.h"
#import "MRProgress.h"
#import "User.h"
#import "QRGenerator.h"
#import "UIImage+MDQRCode.h"
#import "CUEvents.h"
#import "ServiceCallManager.h"

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
    return [error userInfo][@"error"];
}

+ (UIImage *)generateQRCodeWithData: (NSString *)data withSize:(CGFloat)size withFillColor: (UIColor *)fillColor
{
    UIImage *QR = [UIImage mdQRCodeForString:data size:size fillColor:fillColor];
    return QR;
}

+ (NSArray *)getDeliminatedString: (NSString *)string
{
    NSArray *lines = [string componentsSeparatedByString: @"_"];
    return lines;
}

+ (NSArray *)sortEventsAccordingToCurrentDateWithEvents: (NSArray *)events
{
    NSDate *currentDate = [ServiceCallManager getCurrentDate];
    NSArray *res = [events sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CUEvents *o1 = (CUEvents *)obj1;
        CUEvents *o2 = (CUEvents *)obj2;
        // events earlier than currentDate
        if([o1.start compare:currentDate] == NSOrderedAscending &&
           [o2.start compare:currentDate] == NSOrderedDescending)
            return NSOrderedDescending;
        else if([o1.start compare:currentDate] == NSOrderedDescending &&
           [o2.start compare:currentDate] == NSOrderedAscending)
            return NSOrderedAscending;
        // both events are happened before currentDate
        else if([o1.start compare:currentDate] == NSOrderedAscending &&
                [o2.start compare:currentDate] == NSOrderedAscending) {
            if([o1.start compare:o2.start] == NSOrderedAscending)
                return NSOrderedDescending;
            else
                return NSOrderedAscending;
        }
        else {
            return [o1.start compare:o2.start];
        }
    }];
    return res;
};

@end
