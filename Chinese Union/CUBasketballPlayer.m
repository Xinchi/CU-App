//
//  CUFigure.m
//  Chinese Union
//
//  Created by Max Gu on 8/3/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUBasketballPlayer.h"
#import <Parse/PFObject+Subclass.h>

@implementation CUBasketballPlayer

@dynamic name;
@dynamic major;
@dynamic college;
@dynamic year;
@dynamic profilePic;
+ (NSString *)parseClassName {

    return NSStringFromClass([self class]);
}

@end
