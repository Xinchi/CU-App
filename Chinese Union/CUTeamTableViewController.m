//
//  CUTeamTableViewController.m
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUTeamTableViewController.h"
#import "CUContactListTableViewCell.h"
#import "CUPersonnel.h"
#import "CUContactListViewModel.h"
#import "MRProgress.h"
#import "CUFullProfileViewController.h"

static NSString * const cellID = @"cell";

@interface CUTeamTableViewController ()

@property (strong, nonatomic) CUContactListViewModel *viewModel;

@end

@implementation CUTeamTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CUContactListTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:cellID];
    
    self.viewModel = [CUContactListViewModel new];
    self.viewModel.contactType = self.contactType;
    [self bindViewModel];
}

- (void)bindViewModel
{
    [RACObserve(self.viewModel, contacts) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    
    @weakify(self);
    [[self.viewModel.getNewContactsCommand.executing
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.contacts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 141;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CUContactListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    CUPersonnel *person = self.viewModel.contacts[indexPath.row];
    [[self getProfilePicSignalForPerson:person] subscribeNext:^(UIImage *x) {
        cell.profilePicImageView.image = x;
    }];
    cell.nameLabel.text = person.name;
    cell.collegeLabel.text = person.college;
    cell.schoolYearLabel.text = person.year;
    cell.majorLabel.text = person.major;
    
    return cell;
}

- (RACSignal *)getProfilePicSignalForPerson:(CUPersonnel *)person
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [person.profilePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:[UIImage imageWithData:data]];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    CUFullProfileViewController *detailViewController = [[CUFullProfileViewController alloc] initWithNibName:@"CUFullProfileViewController" bundle:nil];
    
    // Pass the selected object to the new view controller.
    CUPersonnel *person = self.viewModel.contacts[indexPath.row];
    detailViewController.person = person;
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
