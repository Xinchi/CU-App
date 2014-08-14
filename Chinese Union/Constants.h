//
//  Constants.h
//  Chinese Union
//
//  Created by Max Gu on 8/10/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject
extern NSString* const CloudFunctionSignupSuccess;
extern NSString* const BATCH1011;
extern NSString* const BATCH1112;
extern NSString* const BATCH1213;
extern NSString* const BATCH1314;

//The parse database fields
extern NSString* const BATCH_FIELD;
extern NSString* const USERNAME_FIELD;
extern NSString* const EMAIL_FIELD;


//The facebook permission fields
extern NSString* const PUBLIC_PROFILE;
extern NSString* const EMAIL;
extern NSString* const USER_BIRTHDAY;

//The facebook fields
extern NSString* const FB_USER_ID;
extern NSString* const FB_USER_FIRST_NAME;
extern NSString* const FB_USER_LAST_NAME;
extern NSString* const FB_USER_EMAIL;
extern NSString* const FB_USER_BIRTHDAY;
extern NSString* const FB_USER_GENDER;

//The facebook configuration
extern NSString* const FB_USER_PROFILE_IMAGE_BASE_URL;


#ifndef Constants_h
#define Constants_h

typedef enum {
    BASKETBALL,
    SOCCER,
    PERSONNEL,
    EVENT
} ObjectType;

#endif

@end