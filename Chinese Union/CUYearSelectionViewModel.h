//
//  CUYearSelectionViewModel.h
//  Chinese Union
//
//  Created by wpliao on 8/19/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "RVMViewModel.h"

@interface CUYearSelectionViewModel : RVMViewModel

@property (strong, nonatomic) NSArray *years;
@property (strong, nonatomic) RACCommand *getYearCommand;

@end
