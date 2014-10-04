//
//  CUTextViewController.m
//  Chinese Union
//
//  Created by wpliao on 10/3/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUTextViewController.h"

@interface CUTextViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation CUTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RAC(self.textView, text) = RACObserve(self, aString);
}

@end
