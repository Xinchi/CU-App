//
//  CUEventViewModel.h
//  Chinese Union
//
//  Created by wpliao on 9/7/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "RVMViewModel.h"

@interface CUEventViewModel : RVMViewModel

@property (strong, nonatomic) NSArray *eventItemViewModels;
@property (strong, nonatomic) RACCommand *getEventsCommand;

@end
