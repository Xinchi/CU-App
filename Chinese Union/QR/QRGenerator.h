//
//  QRGenerator.h
//  Chinese Union
//
//  Created by Max Gu on 7/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRGenerator : NSObject

+ (UIImage *)QRImageWithSize:(CGFloat)size withString:(NSString *)data fillColor:(UIColor *)fillColor;

@end
