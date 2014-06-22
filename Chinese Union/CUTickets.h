//
//  CUTickets.h
//  Chinese Union
//
//  Created by Max Gu on 6/22/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Parse/Parse.h>

@interface CUTickets : PFObject<PFSubclassing>
+(NSString *)parseClassName;

@property(retain) NSString *pid;
@property(retain) NSString *uid;
@property bool checkedIn;
@property(retain) NSDate *expire;

@end
