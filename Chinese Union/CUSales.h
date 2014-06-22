//
//  CUSales.h
//  Chinese Union
//
//  Created by Max Gu on 6/22/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Parse/Parse.h>

@interface CUSales : PFObject<PFSubclassing>
+(NSString *)parseClassName;

@property(retain) NSString *uid;
@property(retain) NSString *pid;
@property(retain) NSNumber *price;
@property NSInteger quantity;
@property(retain) NSString *tickets_id;

@end
