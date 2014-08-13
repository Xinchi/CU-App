//
//  CUFullProfileViewModel.m
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUFullProfileViewModel.h"

@interface CUFullProfileViewModel ()

@end

@implementation CUFullProfileViewModel

- (instancetype)initWithPerson:(id)person {
    self = [super init];
    if (self) {
        self.person = person;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    RACSignal *signal = [self.didBecomeActiveSignal then:^RACSignal *{
        return [self getProfilePicSignal];
    }];
    signal = [self forwardSignalWhileActive:signal];
    [signal subscribeNext:^(UIImage *x) {
        self.profilePic = x;
    }];
}

- (RACSignal *)getProfilePicSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.person.profilePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:[UIImage imageWithData:data]];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

@end
