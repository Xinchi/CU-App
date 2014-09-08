//
//  CUEventItemViewModel.m
//  Chinese Union
//
//  Created by wpliao on 9/7/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUEventItemViewModel.h"
#import "CUEvents.h"
#import "NSDate+Difference.h"
#import "CUTimeManager.h"

@interface CUEventItemViewModel ()

@property (strong, nonatomic) CUEvents *event;

@end

@implementation CUEventItemViewModel

- (id)initWithEvent:(CUEvents *)event
{
    self = [super init];
    if (self) {
        self.event = event;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.name = self.event.name;
    self.description = self.event.description;
    self.duration = self.event.duration;
    
    @weakify(self);
    [RACObserve([CUTimeManager sharedInstance], referenceDate) subscribeNext:^(id x) {
        @strongify(self);
        [self updateTimeToEventAndUnitReferenceDate:x];
    }];
}

- (void)updateTimeToEventAndUnitReferenceDate:(NSDate *)date
{
    MyLog(@"date %@", date);
    NSDictionary *dict = [date differenceToDate:self.event.start];
    self.timeToEvent = dict[CUDateDifferenceValueKey];
    self.timeUnit = dict[CUDateDifferenceStringKey];
}

@end
