//
//  CUYearSelectionViewModel.m
//  Chinese Union
//
//  Created by wpliao on 8/19/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUYearSelectionViewModel.h"
#import "ServiceCallManager.h"

@interface CUYearSelectionViewModel ()

@end

@implementation CUYearSelectionViewModel

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
    self.getYearCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[self getYearsSignal] takeUntil:self.didBecomeInactiveSignal];
    }];
    
    [[self.getYearCommand execute:nil] subscribeNext:^(NSArray *years) {
        MyLog(@"Downloaded %@", years);
        self.years = years;
    }];
    
    [self.getYearCommand.executing subscribeNext:^(id x) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = [x boolValue];
    }];
}

- (RACSignal *)getYearsSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSArray *result = [ServiceCallManager getAllTheBatches];
        [subscriber sendNext:result];
        [subscriber sendCompleted];
        return nil;
    }];
}

@end
