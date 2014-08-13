//
//  CUContactListViewModel.m
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUContactListViewModel.h"
#import "CUPersonnel.h"
#import "ServiceCallManager.h"

@implementation CUContactListViewModel

- (id)init
{
    self = [super init];
    if (self) {
        [self initialized];
    }
    return self;
}

- (void)initialized
{
    self.getNewContactsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[self getNewContactsSignal] takeUntil:self.didBecomeInactiveSignal];
    }];
    
    [[self.getNewContactsCommand execute:nil] subscribeNext:^(NSArray *contacts) {
        MyLog(@"Downloaded");
        self.contacts = contacts;
    }];
    
    [self.getNewContactsCommand.executing subscribeNext:^(id x) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = [x boolValue];
    }];
}

- (RACSignal *)getNewContactsSignal {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        CUPersonnel *person = [CUPersonnel new];
//        person.name = @"Wei Ping Liao";
//        person.college = @"unknown";
//        person.year = @"grad student";
//        person.major = @"computer science";
//        
//        NSArray *result = @[person, person, person, person, person, person, person];
        [ServiceCallManager getAllFigureWithType:self.contactType
                                       WithBlock:^(NSArray *objects, NSError *error) {
                                           if (error) {
                                               [subscriber sendError:error];
                                           }
                                           else {
                                               [subscriber sendNext:objects];
                                               [subscriber sendCompleted];
                                           }
                                       }];        
        return nil;
    }] delay:3.0f];
}

@end
