//
//  CUSales.m
//  Chinese Union
//
//  Created by Max Gu on 6/22/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUSales.h"
#import <Parse/PFObject+Subclass.h>

@implementation CUSales

@dynamic uid;
@dynamic pid;
@dynamic price;
@dynamic quantity;
@dynamic tickets_id;

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}
@end
