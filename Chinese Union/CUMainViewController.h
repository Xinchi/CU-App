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
#import "AppDelegate.h"

@class PAPTabBarController;
@interface CUMainViewController : UIViewController<UICollectionViewDelegate, MosaicLayoutDelegate, CUSignUpViewControllerDelegate, UITabBarControllerDelegate, RemoteNotificationDelegate>

@property (nonatomic, strong) PAPTabBarController *tabBarController;

-(void) cleanupAfterLoggingOut;
@end
