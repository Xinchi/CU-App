//
//  Constants.h
//  Chinese Union
//
//  Created by Max Gu on 8/10/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//
@class User;
@class Order;
#import <Foundation/Foundation.h>

@interface Constants : NSObject
extern NSString* const BATCH1011;
extern NSString* const BATCH1112;
extern NSString* const BATCH1213;
extern NSString* const BATCH1314;
extern NSString* const BATCH1415;

//The parse database fields
extern NSString* const BATCH_FIELD;
extern NSString* const USERNAME_FIELD;
extern NSString* const EMAIL_FIELD;
extern NSString* const CUEVENT_START_DATE;
extern NSString* const ORDERS_CUSTOMER;
extern NSString* const ORDERS_CHARGED;
extern NSString* const CREATION_DATE;


//The facebook permission fields
extern NSString* const PUBLIC_PROFILE;
extern NSString* const EMAIL;
extern NSString* const USER_BIRTHDAY;
extern NSString* const USER_FRIENDS;

//The facebook fields
extern NSString* const FB_USER_ID;
extern NSString* const FB_USER_FIRST_NAME;
extern NSString* const FB_USER_LAST_NAME;
extern NSString* const FB_USER_EMAIL;
extern NSString* const FB_USER_BIRTHDAY;
extern NSString* const FB_USER_GENDER;

//The facebook configuration
extern NSString* const FB_USER_PROFILE_IMAGE_BASE_URL;


//PFObject subclass
extern NSString* const CUBASKETBALLPLAYER_CLASS;
extern NSString* const CUSOCCERPLAYER_CLASS;

//PFCloud function
extern NSString* const CloudFunctionSignupSuccess;
extern NSString* const CloudFunctionGetCurrentDate;
extern NSString* const CloudFunctionGetStaticMembershipExpirationDate;
//Other configurations
extern NSString* const CU_IMAGE_FIELD_KEY;
extern NSString* const CUMemberObjectID;
extern BOOL const STATIC_MEMBERSHIP_ENDING_DATE;

typedef void (^CUUserResultBlock)(User *user, NSError *error);
typedef void (^CUDateResultBlock)(NSDate *date, NSError *error);
typedef void (^CUAppConfigResultBlock)(PFConfig *config, NSError *error);
typedef void (^CUOrderResultBlock)(Order *order, NSError *error);

#ifndef Constants_h
#define Constants_h

typedef enum {
    BASKETBALL,
    SOCCER,
    OFFICER,
    PERSONNEL,
    EVENT
} ObjectType;

typedef enum {
    ASCENDING,
    DESCENDING
} SortOrder;

#endif

@end
