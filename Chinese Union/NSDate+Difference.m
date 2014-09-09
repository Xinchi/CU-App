//
//  NSDate+Difference.m
//  Chinese Union
//
//  Created by wpliao on 9/7/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "NSDate+Difference.h"

NSString * const CUDateDifferenceValueKey = @"value";
NSString * const CUDateDifferenceStringKey = @"string";
NSString * const CUDateDifferenceUnitKey = @"unit";

@implementation NSDate (Difference)

- (NSString *)differenceToDate:(NSDate *)date
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];;
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorianCalendar components:unitFlags
                                                        fromDate:self
                                                          toDate:date
                                                         options:0];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"Expired" forKey:CUDateDifferenceStringKey];
    [dict setValue:@(CUDateUnitExpired) forKey:CUDateDifferenceUnitKey];
    
    if (components.day > 0)
    {
        if (components.day == 1)
        {
            [dict setValue:@"day" forKey:CUDateDifferenceStringKey];
        }
        else
        {
            [dict setValue:@"days" forKey:CUDateDifferenceStringKey];
        }
        
        [dict setValue:@(components.day) forKey:CUDateDifferenceValueKey];
        [dict setValue:@(CUDateUnitDay) forKey:CUDateDifferenceUnitKey];
    }
    else if (components.hour > 0)
    {
        if (components.hour == 1)
        {
            [dict setValue:@"hour" forKey:CUDateDifferenceStringKey];
        }
        else
        {
            [dict setValue:@"hours" forKey:CUDateDifferenceStringKey];
        }
        
        [dict setValue:@(components.hour) forKey:CUDateDifferenceValueKey];
        [dict setValue:@(CUDateUnitHour) forKey:CUDateDifferenceUnitKey];
    }
    else if (components.minute > 0)
    {
        if (components.minute == 1)
        {
            [dict setValue:@"min" forKey:CUDateDifferenceStringKey];
        }
        else
        {
            [dict setValue:@"mins" forKey:CUDateDifferenceStringKey];
            [dict setValue:@(CUDateUnitMin) forKey:CUDateDifferenceUnitKey];
        }
        
        [dict setValue:@(components.minute) forKey:CUDateDifferenceValueKey];
    }
    else if (components.second > 0)
    {
        [dict setValue:@"Less than a min" forKey:CUDateDifferenceStringKey];
        [dict setValue:@(CUDateUnitSecond) forKey:CUDateDifferenceUnitKey];
    }
    
    return [dict copy];
}

@end
