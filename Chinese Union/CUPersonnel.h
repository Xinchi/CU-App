//
//  CUPersonnel.h
//  Chinese Union
//
//  Created by Max Gu on 8/3/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Parse/Parse.h>

@interface CUPersonnel : PFObject<PFSubclassing>

+(NSString *)parseClassName;

@property (retain) NSString *name;
@property (retain) NSString *major;
@property (retain) NSString *college;
@property (retain) NSString *year;
@property (retain) NSString *role;
@property (retain) PFFile *profilePic;

@end
