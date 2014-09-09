//
//  NSDate+Difference.h
//  Chinese Union
//
//  Created by wpliao on 9/7/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CUDateDifferenceValueKey;
extern NSString * const CUDateDifferenceStringKey;
extern NSString * const CUDateDifferenceUnitKey;

typedef NS_ENUM(NSUInteger, CUDateUnit)
{
    CUDateUnitDay = 0,
    CUDateUnitHour,
    CUDateUnitMin,
    CUDateUnitSecond,
    CUDateUnitExpired
};

@interface NSDate (Difference)

- (NSDictionary *)differenceToDate:(NSDate *)date;

@end
