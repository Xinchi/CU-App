//
//  NSDateFormatter+Additions.m
//  Chinese Union
//
//  Created by wpliao on 6/29/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "NSDateFormatter+Additions.h"

@implementation NSDateFormatter (Additions)

+ (NSDateFormatter *)birthdayFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
    });
    
    return formatter;
}

+ (NSDateFormatter *)eventDateFormatter
{
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd EEE";
    });
    
    return formatter;
}

@end
