//
//  CUEditProfileBDViewController.m
//  Chinese Union
//
//  Created by wpliao on 7/1/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUEditProfileBDViewController.h"
#import "NSDateFormatter+Additions.h"
#import "UIViewController+Additions.h"
#import "MBProgressHUD.h"
#import "MRProgress.h"

@interface CUEditProfileBDViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation CUEditProfileBDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.label.text = [[NSDateFormatter birthdayFormatter] stringFromDate:self.birthday];
    self.datePicker.date = self.birthday;
    self.datePicker.maximumDate = [NSDate date];
}

- (IBAction)dateChanged:(UIDatePicker *)sender {
    self.label.text = [[NSDateFormatter birthdayFormatter] stringFromDate:sender.date];
}

- (void)saveButtonPressed {
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    [MRProgressOverlayView dismissAllOverlaysForView:self.navigationController.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
