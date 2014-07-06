//
//  CUEditProfileTextViewController.h
//  Chinese Union
//
//  Created by wpliao on 6/29/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUProfileEditOption.h"

@interface CUEditProfileTextViewController : UIViewController

@property (strong, nonatomic) NSString *text;
@property (nonatomic) CUProfileEditOption option;

@end
