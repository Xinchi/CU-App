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

NSString * const cellID = @"cellID";

@interface CUEventViewController () <UITableViewDataSource, UITabBarDelegate>

@property (strong, nonatomic) CUEventViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CUEventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Events";
    
    self.viewModel = [CUEventViewModel new];
    [self bindViewModel];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CUEventItemTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
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
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.eventItemViewModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CUEventItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    CUEventItemViewModel *viewModel = self.viewModel.eventItemViewModels[indexPath.row];
    [cell bindViewModel:viewModel];
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end
