//
//  CUResizableTextView.m
//  Chinese Union
//
//  Created by wpliao on 10/1/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUResizableTextView.h"

@interface CUResizableTextView ()

@property (nonatomic) CGFloat originalHeight;
@property (weak, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation CUResizableTextView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.originalHeight = self.bounds.size.height;
    self.isOriginal = YES;
    [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
            self.heightConstraint = constraint;
            *stop = YES;
        }
    }];
    
    @weakify(self);
    [RACObserve(self, isOriginal) subscribeNext:^(id x) {
        @strongify(self);
        [self setNeedsUpdateConstraints];
    }];
    
    MyLog(@"Original height: %f", self.originalHeight);
}

- (void)updateConstraints {
    if (self.isOriginal) {
        self.heightConstraint.constant = self.originalHeight;
    }
    else
    {
        // calculate contentSize manually (ios7 doesn't calculate it before viewDidAppear, and we'll get here before)
        CGSize contentSize = [self sizeThatFits:CGSizeMake(self.frame.size.width, FLT_MAX)];
        
        // set the height constraint to change textView height
        self.heightConstraint.constant = contentSize.height;
    }
    
    [super updateConstraints];
}

@end
