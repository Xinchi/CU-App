//
//  CUFullProfileViewController.m
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUFullProfileViewController.h"
#import "CUFullProfileViewModel.h"

@interface CUFullProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *collegeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (strong, nonatomic) CUFullProfileViewModel *viewModel;

@end

@implementation CUFullProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blur_background"]];
    
    self.profilePicImageView.layer.cornerRadius = 8;
    self.profilePicImageView.layer.masksToBounds = YES;
    self.profilePicImageView.layer.borderWidth = 0;
    
    self.title = self.person.name;
    
    self.viewModel = [CUFullProfileViewModel new];
    self.viewModel.person = self.person;
    [self bindViewModel];
}

- (void)bindViewModel
{
    RAC(self.nameLabel, text) = RACObserve(self.viewModel.person, name);
    RAC(self.collegeLabel, text) = RACObserve(self.viewModel.person, college);
    RAC(self.yearLabel, text) = RACObserve(self.viewModel.person, year);
    RAC(self.majorLabel, text) = RACObserve(self.viewModel.person, major);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
