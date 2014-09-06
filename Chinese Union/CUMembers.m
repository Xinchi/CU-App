//
//  CUMember.m
//  Chinese Union
//
//  Created by Max Gu on 6/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUMembers.h"
#import <Parse/PFObject+Subclass.h>

@implementation CUMembers

@dynamic memberUser;
@dynamic activatedDate;
@dynamic expireDate;

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

@end
