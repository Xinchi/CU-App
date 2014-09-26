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

@property (weak, nonatomic) CUTimeManager *manager;
@property (strong, nonatomic) CUEvents *event;

@end

@implementation CUEventItemViewModel

- (id)initWithEvent:(CUEvents *)event timeManager:(CUTimeManager *)manager
{
    self = [super init];
    if (self) {
        self.event = event;
        self.manager = manager;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.name = self.event.name;
    self.eventDescription = self.event.eventDetail;
    self.duration = self.event.duration;
    self.eventDate = self.event.start;
    self.location = self.event.location;
    
    MyLog(@"Event %@", self.event);
    
    @weakify(self);
    [RACObserve(self.manager, referenceDate) subscribeNext:^(id x) {
        @strongify(self);
        [self updateTimeToEventAndUnitReferenceDate:x];
    }];
}

- (void)updateTimeToEventAndUnitReferenceDate:(NSDate *)date
{
    //MyLog(@"date %@", date);
    NSDictionary *dict = [date differenceToDate:self.event.start];
    self.timeToEvent = dict[CUDateDifferenceValueKey];
    self.timeUnit = dict[CUDateDifferenceStringKey];
    
    CUDateUnit unit = [dict[CUDateDifferenceUnitKey] unsignedIntegerValue];
    
    switch (unit) {
        case CUDateUnitDay:
            self.timeUnitColor = [UIColor colorWithRed:0.301 green:0.753 blue:0.576 alpha:1.000];
            break;
            
        case CUDateUnitHour:
            self.timeUnitColor = [UIColor colorWithRed:0.753 green:0.572 blue:0.315 alpha:1.000];
            break;
            
        case CUDateUnitMin:
            self.timeUnitColor = [UIColor colorWithRed:1.000 green:0.333 blue:0.730 alpha:1.000];
            break;
            
        case CUDateUnitSecond:
            self.timeUnitColor = [UIColor redColor];
            break;
            
        case CUDateUnitExpired:
            self.timeUnitColor = [UIColor colorWithWhite:0.341 alpha:1.000];
            break;
            
        default:
            break;
    }
}

@end
