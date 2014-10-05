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
#import "CUEventDetailViewController.h"
#import "MRProgress.h"
#import "CUResizableTextView.h"
#import "PFShippingViewController.h"
#import "ServiceCallManager.h"
//#import "FPPopoverController.h"
#import "CUTextViewController.h"
#import "WYPopoverController.h"
#import "User.h"
#import "Common.h"

NSString * const cellID = @"cellID";
NSString * const bigCellID = @"bigCellID";

@interface CUEventViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CUEventViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) CUEventItemTableViewCell *protoCell;
@property (strong, nonatomic) WYPopoverController *popover;

@end

@implementation CUEventViewController

- (CUEventItemTableViewCell *)protoCell
{
    if (_protoCell == nil) {
        _protoCell = [self.tableView dequeueReusableCellWithIdentifier:bigCellID];
    }
    return _protoCell;
}

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
    
    //[self setupColors];
}

- (void)setupColors
{
    self.colors = @[[UIColor paperColorBlue], [UIColor paperColorBlue], [UIColor paperColorRed], [UIColor paperColorPink], [UIColor paperColorPurple], [UIColor paperColorDeepPurple], [UIColor paperColorIndigo], [UIColor paperColorBlue], [UIColor paperColorLightBlue], [UIColor paperColorCyan], [UIColor paperColorTeal], [UIColor paperColorGreen], [UIColor paperColorLightGreen], [UIColor paperColorLime], [UIColor paperColorYellow], [UIColor paperColorAmber], [UIColor  paperColorDeepOrange], [UIColor paperColorBrown], [UIColor paperColorGray], [UIColor paperColorBlueGray], [UIColor paperColorGray700], [UIColor paperColorGray700]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:YES];
    if ([self isMovingToParentViewController]) {
        [self.viewModel.getEventsCommand execute:nil];
    }
}

- (void)bindViewModel
{
    @weakify(self);
    [RACObserve(self.viewModel, eventItemViewModels) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    self.refreshControl.rac_command = self.viewModel.getEventsCommand;
    [self rac_liftSelector:@selector(sam_displayError:) withSignals:self.viewModel.getEventsCommand.errors, nil];
    
    [[[self.viewModel.getEventsCommand.executing skip:1]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *x) {
         @strongify(self);
         BOOL executing = [x boolValue];
         if (executing) {
             [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
         }
         else {
             [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
             
             if ([self.viewModel.eventItemViewModels count] == 0) {
                 [MRProgressOverlayView showOverlayAddedTo:self.view title:NSLocalizedString(@"No content!", @"") mode:MRProgressOverlayViewModeCross animated:YES];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.navigationController popViewControllerAnimated:YES];
                 });
             }
         }
     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.eventItemViewModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CUEventItemTableViewCell *cell;
//    if (indexPath.row == 0)
//    {
//        cell = [tableView dequeueReusableCellWithIdentifier:bigCellID];
//    }
//    else
//    {
//        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    }
    cell = [tableView dequeueReusableCellWithIdentifier:bigCellID];
    
    CUEventItemViewModel *viewModel = self.viewModel.eventItemViewModels[indexPath.row];
    [cell bindViewModel:viewModel];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [cell.eventDescriptionLabel addGestureRecognizer:gr];
    
    [cell.buyTicketButton addTarget:self action:@selector(buyTicketButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //NSUInteger randomIndex = arc4random() % [self.colors count];
    //cell.textLabel.textColor = self.colors[randomIndex];
    
    return cell;
}

- (void)buyTicketButtonPressed:(UIButton *)sender
{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:sender.superview.superview];
    CUEventItemViewModel *viewModel = self.viewModel.eventItemViewModels[indexpath.row];
    CUProducts *product = viewModel.product;
    
    PFShippingViewController *vc = [[PFShippingViewController alloc] initWithProduct:product size:nil];
    if([User currentUser] == nil)
    {
        [Common showAlertTitle:@"Error" msg:@"Please log in first" onView:self.view];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
//    [[[[[self fetchSignalForObject:product]
//     initially:^{
//        [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
//    }] finally:^{
//        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
//        
//    }] deliverOn:[RACScheduler mainThreadScheduler]]
//     subscribeNext:^(id x) {
//         MyLog(@"Product %@", x);
//         PFShippingViewController *vc = [[PFShippingViewController alloc] initWithProduct:x size:nil];
//         [self.navigationController pushViewController:vc animated:YES];
//     }];
}

//- (RACSignal *)fetchSignalForObject:(PFObject *)product
//{
//    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [product fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//            if (error) {
//                [subscriber sendError:error];
//            }
//            else
//            {
//                [subscriber sendNext:object];
//                [subscriber sendCompleted];
//            }
//        }];
//        return nil;
//    }];
//}

- (void)tapped:(UITapGestureRecognizer *)sender
{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:sender.view.superview.superview];
    CUEventItemViewModel *viewModel = self.viewModel.eventItemViewModels[indexpath.row];
    CUTextViewController *vc = [[CUTextViewController alloc] init];
    vc.aString = viewModel.eventDescription;
    vc.title = @"Description";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    self.popover = [[WYPopoverController alloc] initWithContentViewController:nav];
    self.popover.theme = [WYPopoverTheme themeForIOS7];
    self.popover.popoverLayoutMargins = UIEdgeInsetsMake(40, 40, 40, 40);
    [self.popover presentPopoverFromRect:sender.view.bounds inView:sender.view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];

//    self.popover = [[FPPopoverController alloc] initWithViewController:vc];
//    [self.popover presentPopoverFromView:sender.view];
    
//    viewModel.isExpanded = !viewModel.isExpanded;
//    [self.tableView reloadData];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CUEventItemTableViewCell *cell = self.protoCell;
//    cell.translatesAutoresizingMaskIntoConstraints = NO;
//    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
    
//    CUEventItemViewModel *viewModel = self.viewModel.eventItemViewModels[indexPath.row];
//    [cell bindViewModel:viewModel];
    
//    [cell setNeedsLayout];
//    [cell layoutIfNeeded];

//    CGSize size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height + 1;
    
    return 498;
//    if (indexPath.row == 0)
//    {
//        return 120;
//    }
//    else
//    {
//        return 44;
//    }
}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CUEventItemViewModel *viewModel = self.viewModel.eventItemViewModels[indexPath.row];
//    CUTextViewController *vc = [[CUTextViewController alloc] init];
//    vc.aString = viewModel.eventDescription;
//    
//    CUEventItemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    self.popover = [[FPPopoverController alloc] initWithViewController:vc];
//    [self.popover presentPopoverFromView:cell.eventDescriptionLabel];
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //CUEventItemTableViewCell *cell = (CUEventItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    
//    CUEventDetailViewController *vc = [[CUEventDetailViewController alloc] initWithNibName:@"CUEventDetailViewController" bundle:nil];
//    vc.viewModel = self.viewModel.eventItemViewModels[indexPath.row];
//    //vc.cellColor = cell.tapCircleColor;
//    [self.navigationController pushViewController:vc animated:YES];
//    
//    //NSUInteger randomIndex = arc4random() % [self.colors count];
//    //cell.tapCircleColor = self.colors[randomIndex];
//    //cell.backgroundFadeColor = self.colors[randomIndex];
//}

@end
