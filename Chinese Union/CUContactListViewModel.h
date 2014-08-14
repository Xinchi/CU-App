//
//  CUContactListViewModel.h
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "RVMViewModel.h"
#import "Constants.h"

@interface CUContactListViewModel : RVMViewModel

@property (nonatomic) ObjectType contactType;
@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) RACCommand *getNewContactsCommand;

@end
