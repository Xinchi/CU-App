//
//  CUStoreItems.m
//  Chinese Union
//
//  Created by Max Gu on 6/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUProducts.h"
#import <Parse/PFObject+Subclass.h>

@implementation CUProducts

@dynamic name;
@dynamic description;
@dynamic image;
@dynamic price;
@dynamic price_non_member_male;
@dynamic price_non_member_female;
@dynamic price_member_male;
@dynamic price_member_female;
@dynamic quantity;

+ (NSString *)parseClassName {
    return NSStringFromClass([self class]);
}
@end
