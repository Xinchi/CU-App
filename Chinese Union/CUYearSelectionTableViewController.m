//
//  CUYearSelectionTableViewController.m
//  Chinese Union
//
//  Created by wpliao on 8/19/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUYearSelectionTableViewController.h"
#import "CUYearSelectionViewModel.h"
#import "MRProgress.h"
#import "CUYearSelectionTableViewCell.h"
#import "CUContactTableViewController.h"

static NSString * const cellId = @"cellId";

@interface CUYearSelectionTableViewController ()

@property (strong, nonatomic) CUYearSelectionViewModel *viewModel;

@end

@implementation CUYearSelectionTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Year", @"");
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CUYearSelectionTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    self.viewModel = [CUYearSelectionViewModel new];
    [self bindViewModel];
}

- (void)bindViewModel
{
    @weakify(self);
    [RACObserve(self.viewModel, years) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self rac_liftSelector:@selector(sam_displayError:) withSignals:self.viewModel.getYearCommand.errors, nil];
    
    [[self.viewModel.getYearCommand.executing
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *x) {
         @strongify(self);
         BOOL executing = [x boolValue];
         if (executing) {
             [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
         }
         else {
             [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
         }
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.viewModel.active = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.viewModel.active = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.years count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CUYearSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.yearLabel.text = self.viewModel.years[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CUContactTableViewController *vc = [[CUContactTableViewController alloc] init];
    vc.contactType = self.contactType;
    vc.batch = self.viewModel.years[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
