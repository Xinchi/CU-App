//
//  CUStoreItems.h
//  Chinese Union
//
//  Created by Max Gu on 6/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//


@interface CUProducts : PFObject<PFSubclassing>

+(NSString *)parseClassName;


@property (retain) NSString *name;
@property (retain) NSString *detail;
@property (retain) PFFile *image;
@property (retain) NSNumber *price;
@property (retain) NSNumber *price_non_member_male;
@property (retain) NSNumber *price_non_member_female;
@property (retain) NSNumber *price_member_male;
@property (retain) NSNumber *price_member_female;
@property NSInteger quantityAvailable;

@end
