//
//  CUFullProfileViewModel.h
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "RVMViewModel.h"
#import "CUPersonnel.h"

@interface CUFullProfileViewModel : RVMViewModel

- (instancetype)initWithPerson:(id)person;

@property (strong, nonatomic) CUPersonnel *person;
@property (strong, nonatomic) UIImage *profilePic;

@end
