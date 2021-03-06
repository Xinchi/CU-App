//
//  CUEventItemViewModel.h
//  Chinese Union
//
//  Created by wpliao on 9/7/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "RVMViewModel.h"

@class CUEvents;
@class CUTimeManager;
@class CUProducts;

@interface CUEventItemViewModel : RVMViewModel

- (id)initWithEvent:(CUEvents *)event timeManager:(CUTimeManager *)manager;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *eventDescription;
@property (strong, nonatomic) NSString *duration;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSNumber *timeToEvent;
@property (strong, nonatomic) NSString *timeUnit;
@property (strong, nonatomic) NSDate   *eventDate;
@property (strong, nonatomic) UIColor  *timeUnitColor;
@property (strong, nonatomic) UIImage  *image;
@property (strong, nonatomic) CUProducts *product;

@property (strong, nonatomic) NSString *expandHintString;
@property (nonatomic) BOOL isExpanded;

@end
