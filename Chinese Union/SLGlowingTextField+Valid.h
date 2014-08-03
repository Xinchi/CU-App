//
//  SLGlowingTextField+Valid.h
//  Chinese Union
//
//  Created by wpliao on 8/3/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "SLGlowingTextField.h"

@interface SLGlowingTextField (Valid)

- (void)inValidate;
- (void)validate;
- (BOOL)validLength;
- (BOOL)validString:(NSString *)string;
- (BOOL)validEmailFormat;
- (BOOL)checkCondition:(BOOL)condition;

@end
