//
//  CUOfficers.h
//  Chinese Union
//
//  Created by Max Gu on 10/15/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Parse/Parse.h>

@interface CUOfficers : PFObject<PFSubclassing>

+(NSString *)parseClassName;

@property (retain) NSString *name;
@property (retain) NSString *major;
@property (retain) NSString *college;
@property (retain) NSString *year;
@property (retain) NSString *role;
@property (retain) PFFile *profilePic;
//remmeber to do a null check on associatedPerson.  It can be null
@property (retain) User *associatedPerson;

@end
