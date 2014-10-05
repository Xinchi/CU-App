//
//  NSArray+Additions.h
//  Chinese Union
//
//  Created by wpliao on 10/4/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)

- (BOOL)containsObjectOfClass:(Class)aClass;
- (NSUInteger)indexOfObjectOfClass:(Class)aClass;

@end
