//
//  Orders.h
//  Chinese Union
//
//  Created by Max Gu on 9/23/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//


@class User;
@class CUProducts;
@interface Order : PFObject<PFSubclassing>
+(NSString *)parseClassName;

@property (retain) User *customer;
@property (retain) CUProducts *item;
@property (retain) NSString *name;
@property (retain) NSString *product;
@property (retain) NSString *size;
@property (retain) NSString *address;
@property (retain) NSString *email;
@property (retain) NSString *zip;
@property bool fulfilled;
@property (retain) NSDate *redeemed;

@end
