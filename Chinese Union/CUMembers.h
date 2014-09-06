//
//  CUMember.h
//  Chinese Union
//
//  Created by Max Gu on 6/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

@class User;
@interface CUMembers : PFObject<PFSubclassing>
+(NSString *)parseClassName;

@property (retain) User *memberUser;
@property (retain) NSDate *activatedDate;
@property (retain) NSDate *expireDate;

@end
