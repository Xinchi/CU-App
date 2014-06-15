//
//  NSString+Additions.h
//  Blink
//
//  Created by 維平 廖 on 13/4/30.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (NSString *)cleanString;
- (BOOL)hasNoContent;
- (BOOL)isEmailFormat;
- (BOOL)isAlphaNumeric;

@end
