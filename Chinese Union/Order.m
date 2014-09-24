//
//  Orders.m
//  Chinese Union
//
//  Created by Max Gu on 9/23/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "Order.h"
#import <Parse/PFObject+Subclass.h>

@implementation Order

@dynamic customer;
@dynamic item;
@dynamic name;
@dynamic product;
@dynamic size;
@dynamic address;
@dynamic email;
@dynamic fulfilled;
@dynamic redeemed;

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}

@end
