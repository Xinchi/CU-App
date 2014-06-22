//
//  CUMember.h
//  Chinese Union
//
//  Created by Max Gu on 6/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//


@interface CUMembers : PFObject<PFSubclassing>
+(NSString *)parseClassName;

@property (retain) NSString *uid;
@property (retain) NSDate *activatedDate;
@property (retain) NSDate *expireDate;

@end
