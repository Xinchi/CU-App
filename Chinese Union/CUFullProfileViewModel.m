//
//  CUFullProfileViewModel.m
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUFullProfileViewModel.h"

@interface CUFullProfileViewModel ()

@property (strong, nonatomic) User *person;

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
//    RACSignal *signal = [self.didBecomeActiveSignal then:^RACSignal *{
//        return [self getProfilePicSignal];
//    }];
//    signal = [self forwardSignalWhileActive:signal];
    RACSignal *signal = [self getProfilePicSignal];
    
    @weakify(self);
    [signal subscribeNext:^(UIImage *x) {
        @strongify(self);
        self.profilePic = x;
    }];
    
    self.name = [NSString stringWithFormat:@"Name: %@ %@", self.person.firstName, self.person.lastName];
    self.email = [NSString stringWithFormat:@"EMail: %@", self.person.email];
    self.phone = [NSString stringWithFormat:@"Phone: %@", self.person.phone];
    self.gender = [NSString stringWithFormat:@"Gender: %@", self.person.gender];
    self.wechatId = [NSString stringWithFormat:@"WeChat: %@", self.person.wechatID];
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
