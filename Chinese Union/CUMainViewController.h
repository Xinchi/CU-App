//
//  CUMainViewController.h
//  Chinese Union
//
//  Created by wpliao on 2014/6/4.
//  Copyright (c) 2014年 ucsd.ChineseUnion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosaicLayoutDelegate.h"
#import "SignUpViewController.h"

@interface CUMainViewController : UIViewController<UICollectionViewDelegate, MosaicLayoutDelegate, CUSignUpViewControllerDelegate>

@end
