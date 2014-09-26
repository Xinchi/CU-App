//
//  CUFullProfileViewModel.h
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "RVMViewModel.h"
#import "User.h"

@interface CUFullProfileViewModel : RVMViewModel

- (instancetype)initWithPerson:(id)person;

@property (strong, nonatomic) UIImage *profilePic;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *wechatId;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *gender;

@end
