//
//  CUTimeManager.m
//  Chinese Union
//
//  Created by wpliao on 9/7/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUTimeManager.h"

@implementation CUTimeManager

+ (instancetype)sharedInstance
{
    static CUTimeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CUTimeManager alloc] init];
        manager.referenceDate = [NSDate date];
    });
    
    return manager;
}

@end
