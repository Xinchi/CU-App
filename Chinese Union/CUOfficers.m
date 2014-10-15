//
//  CUOfficers.m
//  Chinese Union
//
//  Created by Max Gu on 10/15/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUOfficers.h"
#import "User.h"
#import <Parse/PFObject+Subclass.h>

@implementation CUOfficers

@dynamic name;
@dynamic major;
@dynamic college;
@dynamic year;
@dynamic role;
@dynamic profilePic;
@dynamic associatedPerson;

+ (NSString *)parseClassName {
    
    return NSStringFromClass([self class]);
}


@end
