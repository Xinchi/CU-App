//
//  SLGlowingTextField+Valid.m
//  Chinese Union
//
//  Created by wpliao on 8/3/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "SLGlowingTextField+Valid.h"
#import "NSString+Additions.h"

@implementation SLGlowingTextField (Valid)

- (void)inValidate {
    self.alwaysGlowing = YES;
    self.glowingColor = [UIColor colorWithRed:1.000 green:0.180 blue:0.097 alpha:1.000];
}

- (void)validate {
    self.alwaysGlowing = NO;
    self.glowingColor = [UIColor colorWithRed:(82.f / 255.f) green:(168.f / 255.f) blue:(236.f / 255.f) alpha:0.8];
}

- (BOOL)validLength {
    return [self checkCondition:[self.text cleanString].length > 0];
}

- (BOOL)validString:(NSString *)string {
    return [self checkCondition:[self.text isEqualToString:string]];
}

- (BOOL)validEmailFormat {
    return [self checkCondition:[self.text isEmailFormat]];
}

- (BOOL)checkCondition:(BOOL)condition {
    if (!condition) {
        [self inValidate];
    }
    else {
        [self validate];
    }
    return condition;
}

@end
