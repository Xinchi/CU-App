//
//  NSArray+Additions.m
//  Chinese Union
//
//  Created by wpliao on 10/4/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (BOOL)containsObjectOfClass:(Class)aClass
{
    __block BOOL result = NO;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:aClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    
    return result;
}

- (NSUInteger)indexOfObjectOfClass:(Class)aClass
{
    return [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        BOOL result = NO;
        if ([obj isKindOfClass:aClass]) {
            *stop = YES;
            result = YES;
        }
        return result;
    }];
}

@end
