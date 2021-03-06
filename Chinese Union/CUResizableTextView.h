//
//  CUResizableTextView.h
//  Chinese Union
//
//  Created by wpliao on 10/1/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUResizableTextView : UITextView

@property (nonatomic) BOOL isOriginal;
@property (nonatomic) BOOL hasMoreText;
@property (nonatomic) CGFloat originalHeight;
@property (weak, nonatomic) NSLayoutConstraint *heightConstraint;

@end
