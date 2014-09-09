//
//  CUEventDetailViewController.h
//  Chinese Union
//
//  Created by wpliao on 9/8/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CUEventItemViewModel;

@interface CUEventDetailViewController : UIViewController

@property (strong, nonatomic) CUEventItemViewModel *viewModel;
@property (strong, nonatomic) UIColor *cellColor;

@end
