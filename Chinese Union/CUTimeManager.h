//
//  CUTimeManager.h
//  Chinese Union
//
//  Created by wpliao on 9/7/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CUTimeManager : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic) NSDate *referenceDate;

@end
