//
//  CUEvent.h
//  Chinese Union
//
//  Created by Max Gu on 6/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//


@interface CUEvents : PFObject<PFSubclassing>
+(NSString *)parseClassName;

@property(retain) NSString *name;
@property(retain) NSString *description;
@property(retain) NSString *venue;
@property(retain) NSDate *start;
@property(retain) NSString *duration;
@property(retain) NSString *pid;

@end
