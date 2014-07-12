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
    
    if (self.gender == CUProfileEditGenderMale) {
        self.segmentedControl.selectedSegmentIndex = 0;
    }
    else
    {
        self.segmentedControl.selectedSegmentIndex = 1;
    }
}

- (void)saveButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
