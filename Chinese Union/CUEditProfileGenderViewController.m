//
//  CUEditProfileGenderViewController.m
//  Chinese Union
//
//  Created by wpliao on 7/12/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUEditProfileGenderViewController.h"
#import "UIViewController+Additions.h"

@interface CUEditProfileGenderViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation CUEditProfileGenderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self.gender isEqualToString:kMale]) {
        self.segmentedControl.selectedSegmentIndex = 0;
    }
    else
    {
        self.segmentedControl.selectedSegmentIndex = 1;
    }
}

- (void)saveButtonPressed {
    // Use kMale for male string and kFemale for female string
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        kMale;
    }
    else {
        kFemale;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
