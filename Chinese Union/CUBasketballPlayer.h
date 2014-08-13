//
//  CUFigure.h
//  Chinese Union
//
//  Created by Max Gu on 8/3/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

@interface CUBasketballPlayer: PFObject<PFSubclassing>


+(NSString *)parseClassName;

@property (retain) NSString *name;
@property (retain) NSString *major;
@property (retain) NSString *college;
@property (retain) NSString *year;
@property (retain) PFFile *profilePic;

@end
