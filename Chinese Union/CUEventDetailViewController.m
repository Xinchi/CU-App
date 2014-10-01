//
//  CUEventDetailViewController.m
//  Chinese Union
//
//  Created by wpliao on 9/8/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUEventDetailViewController.h"
#import "CUEventItemViewModel.h"
#import "CUEventItemTableViewCell.h"

@interface CUEventDetailViewController ()

@property (strong, nonatomic) CUEventItemTableViewCell *cell;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation CUEventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.viewModel.name;
    
    UINib *nib = [UINib nibWithNibName:@"CUEventItemBigTableViewCell" bundle:nil];
    self.cell = [[nib instantiateWithOwner:nil options:nil] firstObject];
    //self.cell.tapCircleColor = self.cellColor;
    //self.cell.backgroundFadeColor = self.cellColor;
//    self.cell.layer.cornerRadius = 6;
//    self.cell.layer.masksToBounds = YES;
//    self.cell.layer.borderWidth = 1;
//    self.cell.layer.borderColor = self.cellColor.CGColor;
//    self.cell.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.cell.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
//    self.cell.layer.shadowOpacity = 0.5f;
    
    [self.cell bindViewModel:self.viewModel];
    [self.cellView addSubview:self.cell];
    
    [self.cell autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    RAC(self.textView, text) = RACObserve(self.viewModel, eventDescription);
}

@end
