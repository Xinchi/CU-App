//
//  CUEvent.m
//  Chinese Union
//
//  Created by Max Gu on 6/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUEvents.h"
#import <Parse/PFObject+Subclass.h>

@implementation CUEvents

@dynamic name;
@dynamic description;
@dynamic start;
@dynamic duration;
@dynamic venue;
@dynamic product;
@dynamic image;

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

@end
