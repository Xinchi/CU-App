//
//  CUTeamTableViewController.m
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUContactTableViewController.h"
#import "CUContactListTableViewCell.h"
#import "CUPersonnel.h"
#import "CUContactListViewModel.h"
#import "MRProgress.h"
#import "CUFullProfileViewController.h"
#import "CUInsetLabel.h"

static NSString * const cellID = @"cell";
static NSString * const cellIDPersonnel = @"cell2";

@interface CUContactTableViewController ()

@property (strong, nonatomic) CUContactListViewModel *viewModel;

@end

@implementation CUContactTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    switch (self.contactType) {
        case BASKETBALL:
            self.title = NSLocalizedString(@"Basketball", @"");
            break;
            
        case SOCCER:
            self.title = NSLocalizedString(@"Soccer", @"");
            break;
            
        case PERSONNEL:
            self.title = NSLocalizedString(@"Contacts", @"");
            break;
            
        case OFFICER:
            self.title = NSLocalizedString(@"Officers", @"");
            
        default:
            break;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CUContactListTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:cellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"CUPersonnelListTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:cellIDPersonnel];
    
    self.viewModel = [[CUContactListViewModel alloc] initWithContactType:self.contactType batch:self.batch];
    [self bindViewModel];
}

- (void)bindViewModel
{
    @weakify(self);
    [RACObserve(self.viewModel, contacts) subscribeNext:^(NSArray *x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self rac_liftSelector:@selector(sam_displayError:) withSignals:self.viewModel.getNewContactsCommand.errors, nil];
    
    [[[self.viewModel.getNewContactsCommand.executing skip:1]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *x) {
        @strongify(self);
        BOOL executing = [x boolValue];
        if (executing) {
            [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
        }
        else {
            [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
            
            if ([self.viewModel.contacts count] == 0) {
                [MRProgressOverlayView showOverlayAddedTo:self.view title:NSLocalizedString(@"No content!", @"") mode:MRProgressOverlayViewModeCross animated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
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
    if (self.contactType == PERSONNEL || self.contactType == OFFICER) {
        return 162;
    }
    return 141;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CUContactListTableViewCell *cell;
    if (self.contactType == PERSONNEL || self.contactType == OFFICER) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDPersonnel forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    }
    
    CUPersonnel *person = self.viewModel.contacts[indexPath.row];
    cell.nameLabel.text = person.name;
    if ([person respondsToSelector:@selector(role)]) {
        cell.roleLabel.text = person.role;
    }
    cell.collegeLabel.text = person.college;
    cell.schoolYearLabel.text = person.year;
    cell.majorLabel.text = person.major;
    cell.profilePicImageView.image = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (person.associatedPerson != nil) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    [[[self getProfilePicSignalForPerson:person]
      takeUntil:[cell rac_prepareForReuseSignal]]
     subscribeNext:^(UIImage *x) {
         MyLog(@"image get! %@",cell);
         cell.profilePicImageView.image = x;
     }];
    
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
    if (person.associatedPerson != nil) {
        detailViewController.person = person.associatedPerson;
        
        // Push the view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}


@end
