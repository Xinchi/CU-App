//
//  CUPurchaseHistoryDetailTableViewController.m
//  Chinese Union
//
//  Created by wpliao on 10/2/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUPurchaseHistoryDetailTableViewController.h"
#import "Order.h"
#import "CUProducts.h"

NSString * const cellId = @"cellId";

@interface CUPurchaseHistoryDetailTableViewController ()

@property (strong, nonatomic) Order *order;

@end

@implementation CUPurchaseHistoryDetailTableViewController

- (instancetype)initWithOrder:(Order *)order
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.order = order;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[PFTableViewCell class] forCellReuseIdentifier:cellId];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 3;
    }
    else if (section == 1) {
        return 3;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"Product", @"");
    }
    else
    {
        return NSLocalizedString(@"Billing", @"");
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.imageView.image = nil;
    cell.textLabel.text = nil;
    
    if (indexPath.section == 0) {
        CUProducts *product = self.order.item;
        
        if (indexPath.row == 0) {
            cell.imageView.file = product.image;
            cell.textLabel.text = product.name;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"Price: $%@", [product.price stringValue]];
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = [NSString stringWithFormat:@"Description: %@", product.description];
        }
    }
    else {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"Order ID: %@", self.order.objectId];
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"Name: %@", self.order.name];
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = [NSString stringWithFormat:@"Address: %@", self.order.address];
        }
    }
    
    return cell;
}

@end
