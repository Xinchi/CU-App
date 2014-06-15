//
//  CUEvent.h
//  Chinese Union
//
//  Created by Max Gu on 6/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//


@interface CUEvents : PFObject<PFSubclassing>
+(NSString *)parseClassName;

@property(retain) NSString *eventName;
@property(retain) NSString *eventDescription;
@property(retain) NSString *eventVenue;
@property(retain) NSString *eventDuration;

@end
