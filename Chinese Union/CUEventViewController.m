//
//  CUEventViewController.m
//  Chinese Union
//
//  Created by wpliao on 8/3/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUEventViewController.h"
#import "CUEventViewModel.h"
#import "CUEventItemViewModel.h"
#import "CUEventItemTableViewCell.h"
#import "UIColor+BFPaperColors.h"

NSString * const cellID = @"cellID";
NSString * const bigCellID = @"bigCellID";

@interface CUEventViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CUEventViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *colors;

@end

@implementation CUEventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Events";
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blur_White"]];
//    self.tableView.layer.cornerRadius = 8;
//    self.tableView.layer.masksToBounds = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CUEventItemTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"CUEventItemBigTableViewCell" bundle:nil] forCellReuseIdentifier:bigCellID];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    
    self.viewModel = [CUEventViewModel new];
    [self bindViewModel];
    
    [self setupColors];
}

- (void)setupColors
{
    self.colors = @[[UIColor paperColorBlue], [UIColor paperColorBlue], [UIColor paperColorRed], [UIColor paperColorPink], [UIColor paperColorPurple], [UIColor paperColorDeepPurple], [UIColor paperColorIndigo], [UIColor paperColorBlue], [UIColor paperColorLightBlue], [UIColor paperColorCyan], [UIColor paperColorTeal], [UIColor paperColorGreen], [UIColor paperColorLightGreen], [UIColor paperColorLime], [UIColor paperColorYellow], [UIColor paperColorAmber], [UIColor  paperColorDeepOrange], [UIColor paperColorBrown], [UIColor paperColorGray], [UIColor paperColorBlueGray], [UIColor paperColorGray700], [UIColor paperColorGray700]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.viewModel.getEventsCommand execute:nil];
}

- (void)bindViewModel
{
    @weakify(self);
    [RACObserve(self.viewModel, eventItemViewModels) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    self.refreshControl.rac_command = self.viewModel.getEventsCommand;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.eventItemViewModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CUEventItemTableViewCell *cell;
    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:bigCellID];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    
    CUEventItemViewModel *viewModel = self.viewModel.eventItemViewModels[indexPath.row];
    [cell bindViewModel:viewModel];
    
    NSUInteger randomIndex = arc4random() % [self.colors count];
    cell.textLabel.textColor = self.colors[randomIndex];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 120;
    }
    else
    {
        return 44;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CUEventItemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUInteger randomIndex = arc4random() % [self.colors count];
    cell.tapCircleColor = self.colors[randomIndex];
    cell.backgroundFadeColor = self.colors[randomIndex];
}

@end
