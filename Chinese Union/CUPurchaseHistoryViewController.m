//
//  CUPurchaseHistoryViewController.m
//  Chinese Union
//
//  Created by wpliao on 10/1/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUPurchaseHistoryViewController.h"
#import "Order.h"
#import "User.h"
#import "CUProducts.h"
#import "CUPurchaseHistoryDetailTableViewController.h"

@interface CUPurchaseHistoryViewController ()

@end

@implementation CUPurchaseHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = NSLocalizedString(@"Purchase History", @"");
}

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        [self.tableView setSeparatorColor:[UIColor colorWithRed:210.0f/255.0f green:203.0f/255.0f blue:182.0f/255.0f alpha:1.0]];
    }
    return self;
}


#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {

    PFQuery *query = [Order query];
    [query whereKey:ORDERS_CUSTOMER equalTo:[User currentUser]];
    [query orderByAscending:CREATION_DATE];
    [query includeKey:@"item"];
    [query includeKey:@"customer"];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(Order *)object {
    static NSString *cellID = @"cellID";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.imageView.file = object.item.image;
    cell.textLabel.text = object.item.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@", [object.item.price stringValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CUPurchaseHistoryDetailTableViewController *vc = [[CUPurchaseHistoryDetailTableViewController alloc] initWithOrder:[self objectAtIndexPath:indexPath]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    //MyLog(@"ObectsDidLoad %@", self.objects);
}

@end
