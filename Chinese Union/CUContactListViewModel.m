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

@interface CUContactListViewModel ()

@property (nonatomic) ObjectType contactType;
@property (strong, nonatomic) NSString *batch;

@end

@implementation CUContactListViewModel

- (id)initWithContactType:(ObjectType)type batch:(NSString *)batch
{
    self = [super init];
    if (self) {
        self.contactType = type;
        self.batch = batch;
        [self initialized];
    }
    return self;
}

- (void)initialized
{
    self.getNewContactsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[self getNewContactsSignalWithBatch:self.batch] takeUntil:self.didBecomeInactiveSignal];
    }];
    
    [[self.getNewContactsCommand execute:nil] subscribeNext:^(NSArray *contacts) {
        MyLog(@"Downloaded %@", contacts);
        self.contacts = contacts;
    }];
    
    [self.getNewContactsCommand.executing subscribeNext:^(id x) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = [x boolValue];
    }];
}

- (RACSignal *)getNewContactsSignalWithBatch:(NSString *)batch {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        CUPersonnel *person = [CUPersonnel new];
//        person.name = @"Wei Ping Liao";
//        person.college = @"unknown";
//        person.year = @"grad student";
//        person.major = @"computer science";
//        
//        NSArray *result = @[person, person, person, person, person, person, person];

        [ServiceCallManager getObjectsWithType:self.contactType WithBatch:batch WithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:objects];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

@end
