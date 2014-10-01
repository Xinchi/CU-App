//
//  CUEvent.h
//  Chinese Union
//
//  Created by Max Gu on 6/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

@class CUProducts;
@interface CUEvents : PFObject<PFSubclassing>
+(NSString *)parseClassName;

@property(retain) NSString *name;
@property(retain) NSString *eventDetail;
@property(retain) NSString *location;
@property(retain) NSDate *start;
@property(retain) NSString *duration;
@property(retain) PFFile *image;
@property(retain) CUProducts *product;
@property(retain) PFGeoPoint *locationGeoPoint;

@end
