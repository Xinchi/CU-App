//
//  CUEventItemTableViewCell.h
//  Chinese Union
//
//  Created by wpliao on 9/7/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFPaperTableViewCell.h"

@class CUEventItemViewModel;

@interface CUEventItemTableViewCell : BFPaperTableViewCell

- (void)bindViewModel:(CUEventItemViewModel *)viewModel;

@end
