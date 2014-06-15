//
//  User.h
//  Chinese Union
//
//  Created by Max Gu on 6/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser<PFSubclassing>

@property (retain) NSString *firstName;
@property (retain) NSString *lastName;
@property (retain) NSString *CUMemberID;
@property (retain) NSString *wechatID;
@property (retain) NSDate *birthday;
@property (retain) NSString *phone;

@end
