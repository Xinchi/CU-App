//
//  CULoginViewController.h
//  Chinese Union
//
//  Created by wpliao on 2014/6/14.
//  Copyright (c) 2014年 ucsd.ChineseUnion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CUSignUpViewControllerDelegate;


@interface CULoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) id<CUSignUpViewControllerDelegate> delegate;
@end
