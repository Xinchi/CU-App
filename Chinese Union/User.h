//
//  User.h
//  Chinese Union
//
//  Created by Max Gu on 6/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Parse/Parse.h>
@class CUMembers;
@interface User : PFUser<PFSubclassing>

@property (retain) NSString *objectId;
@property (retain) NSString *role;
@property (retain) NSString *firstName;
@property (retain) NSString *lastName;
@property (retain) NSString *gender;
@property (retain) CUMembers *cuMember;
@property (retain) NSString *wechatID;
@property (retain) NSDate *birthday;
@property (retain) NSString *phone;
@property (retain) PFFile *profilePic;
@property (retain) PFFile *IDPic;
@property BOOL emailVerified;
@property BOOL IDPicVerified;

@end
