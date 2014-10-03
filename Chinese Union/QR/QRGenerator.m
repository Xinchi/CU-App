//
//  QRGenerator.m
//  Chinese Union
//
//  Created by Max Gu on 7/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "QRGenerator.h"
#import "User.h"
#import "UIImage+MDQRCode.h"

@implementation QRGenerator

+ (UIImage *)QRImageWithSize:(CGFloat)size fillColor:(UIColor *)fillColor
{
    User *user = [User currentUser];
    if(!user)
        return nil;
    else{
        
        UIImage *QR = [UIImage mdQRCodeForString:user.objectId size:size fillColor:fillColor];
        return QR;
    }
    return nil;
}

+ (UIImage *)QRImageWithSize:(CGFloat)size withString:(NSString *)data fillColor:(UIColor *)fillColor
{
    UIImage *QR = [UIImage mdQRCodeForString:data size:size fillColor:fillColor];
    return QR;
}
@end
