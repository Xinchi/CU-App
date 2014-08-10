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
    }
    return self;
}

@end
