//
//  CUStoreItems.h
//  Chinese Union
//
//  Created by Max Gu on 6/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//


@interface CUStoreItems : PFObject<PFSubclassing>

+(NSString *)parseClassName;


@property (retain) NSString *name;
@property (retain) NSString *description;
@property (retain) PFFile *image;
@property (retain) NSNumber *price_non_member_male;
@property (retain) NSNumber *price_non_member_female;
@property (retain) NSNumber *price_member_male;
@property (retain) NSNumber *price_member_female;
@property NSInteger quantity;

@end
