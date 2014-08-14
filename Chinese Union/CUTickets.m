//
//  CUTickets.m
//  Chinese Union
//
//  Created by Max Gu on 6/22/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUTickets.h"
#import <Parse/PFObject+Subclass.h>

@implementation CUTickets

@dynamic pid;
@dynamic uid;
@dynamic checkedIn;
@dynamic expire;

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

@end
