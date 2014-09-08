//
//  CUEventViewModel.m
//  Chinese Union
//
//  Created by wpliao on 9/7/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUEventViewModel.h"
#import "CUEventItemViewModel.h"
#import "CUEvents.h"
#import "CUTimeManager.h"

@implementation CUEventViewModel

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.getEventsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self getEventsSignal];
    }];
    
    @weakify(self);
    [[self.getEventsCommand.executionSignals switchToLatest] subscribeNext:^(NSArray *x) {
        @strongify(self);
        NSMutableArray *array = [NSMutableArray array];
        for (CUEvents *event in x) {
            CUEventItemViewModel *model = [[CUEventItemViewModel alloc] initWithEvent:event timeManager:[CUTimeManager sharedInstance]];
            [array addObject:model];
        }
        self.eventItemViewModels = [array copy];
    }];
}

- (RACSignal *)getEventsSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDate *today = [CUTimeManager sharedInstance].referenceDate;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components;
        
        components = [[NSDateComponents alloc] init];
        components.hour = -1;
        CUEvents *event1 = [[CUEvents alloc] init];
        event1.name = @"Event 1";
        event1.description = @"expired";
        event1.start = [calendar dateByAddingComponents:components
                                                 toDate:today
                                                options:0];
        event1.duration = @"2 hours";
        
        components = [[NSDateComponents alloc] init];
        components.hour = 1;
        CUEvents *event2 = [[CUEvents alloc] init];
        event2.name = @"Event 2";
        event2.description = @"1 hour after";
        event2.start = [calendar dateByAddingComponents:components
                                                 toDate:today
                                                options:0];
        event2.duration = @"2 hours";
        
        components = [[NSDateComponents alloc] init];
        components.hour = 2;
        CUEvents *event3 = [[CUEvents alloc] init];
        event3.name = @"Event 3";
        event3.description = @"2 hours after";
        event3.start = [calendar dateByAddingComponents:components
                                                 toDate:today
                                                options:0];
        event3.duration = @"2 hours";
        
        components = [[NSDateComponents alloc] init];
        components.day = 1;
        CUEvents *event4 = [[CUEvents alloc] init];
        event4.name = @"Event 4";
        event4.description = @"1 day after";
        event4.start = [calendar dateByAddingComponents:components
                                                 toDate:today
                                                options:0];
        event4.duration = @"2 hours";
        
        components = [[NSDateComponents alloc] init];
        components.day = 2;
        CUEvents *event5 = [[CUEvents alloc] init];
        event5.name = @"Event 5";
        event5.description = @"2 days after";
        event5.start = [calendar dateByAddingComponents:components
                                                 toDate:today
                                                options:0];
        event5.duration = @"2 hours";
        
        components = [[NSDateComponents alloc] init];
        components.minute = 30;
        CUEvents *event6 = [[CUEvents alloc] init];
        event6.name = @"Event 6";
        event6.description = @"2 days after";
        event6.start = [calendar dateByAddingComponents:components
                                                 toDate:today
                                                options:0];
        event6.duration = @"2 hours";
        
        components = [[NSDateComponents alloc] init];
        components.second = 30;
        CUEvents *event7 = [[CUEvents alloc] init];
        event7.name = @"Event 7";
        event7.description = @"2 days after";
        event7.start = [calendar dateByAddingComponents:components
                                                 toDate:today
                                                options:0];
        event7.duration = @"2 hours";
        
        [subscriber sendNext:@[event7, event2, event1, event3, event4, event5, event6, event7]];
        [subscriber sendCompleted];
        
        return nil;
    }];
}

@end
