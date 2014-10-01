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

@interface CUPurchaseHistoryViewController ()

@end

@implementation CUPurchaseHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    return query;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
//    static UITableViewCell *FriendCellIdentifier;
//    return FriendCellIdentifier;
//}


- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    MyLog(@"ObectsDidLoad");
}





@end
