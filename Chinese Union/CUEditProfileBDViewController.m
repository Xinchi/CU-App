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
#import "User.h"

@interface CUEditProfileBDViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation CUEditProfileBDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *dateString;
    NSDate *date;
    if (self.birthday) {
        dateString = [[NSDateFormatter birthdayFormatter] stringFromDate:self.birthday];
        date = self.birthday;
    }
    else {
        dateString = NSLocalizedString(@"Select Birthday", @"");
        date = [NSDate date];
    }
    
    self.label.text = dateString;
    self.datePicker.date = date;
    self.datePicker.maximumDate = [NSDate date];
}

- (IBAction)dateChanged:(UIDatePicker *)sender {
    self.label.text = [[NSDateFormatter birthdayFormatter] stringFromDate:sender.date];
}

- (void)saveButtonPressed {
    User *user = [User currentUser];
    user.birthday = self.datePicker.date;
    [user save];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
