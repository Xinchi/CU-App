//
//  CUFullProfileViewController.m
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUFullProfileViewController.h"
#import "CUFullProfileViewModel.h"
#import "ServiceCallManager.h"

@interface CUFullProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wechatLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
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
    
    self.profilePicImageView.image = nil;
    self.profilePicImageView.layer.cornerRadius = 8;
    self.profilePicImageView.layer.masksToBounds = YES;
    self.profilePicImageView.layer.borderWidth = 0;
    
    //we need to pull the person info first
    self.person = (User *)[ServiceCallManager fecthForObject:self.person];
    self.title = [NSString stringWithFormat:@"%@ %@", self.person.firstName, self.person.lastName];
    
    self.viewModel = [[CUFullProfileViewModel alloc] initWithPerson:self.person];
    [self bindViewModel];
}

- (void)bindViewModel
{
    RAC(self.nameLabel, text) = RACObserve(self.viewModel, name);
    RAC(self.wechatLabel, text) = RACObserve(self.viewModel, wechatId);
//    RAC(self.yearLabel, text) = RACObserve(self.viewModel.person, year);
//    RAC(self.majorLabel, text) = RACObserve(self.viewModel.person, major);
    RAC(self.profilePicImageView, image) = RACObserve(self.viewModel, profilePic);
    // TODO: More info needs to be displayed here.  (email, phone, gender, and QR Code)
    RAC(self.emailLabel, text) = RACObserve(self.viewModel, email);
    RAC(self.phoneLabel, text) = RACObserve(self.viewModel, phone);
    RAC(self.genderLabel, text) = RACObserve(self.viewModel, gender);    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
