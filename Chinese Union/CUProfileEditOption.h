//
//  CUProfileEditOption.h
//  Chinese Union
//
//  Created by wpliao on 7/6/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#ifndef Chinese_Union_CUProfileEditOption_h
#define Chinese_Union_CUProfileEditOption_h

static NSString *kMale = @"Male";
static NSString *kFemale = @"Female";

typedef NS_ENUM(NSInteger, CUProfileEditOption) {
    CUProfileEditFirstName,
    CUProfileEditLastName,
    CUProfileEditEmail,
    CUProfileEditGender,
    CUProfileEditPhone,
    CUProfileEditWeChat
};

#endif
