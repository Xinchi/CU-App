//
//  CUPurchaseHistoryDetailTableViewController.h
//  Chinese Union
//
//  Created by wpliao on 10/2/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Order;

@interface CUPurchaseHistoryDetailTableViewController : UITableViewController

- (instancetype)initWithOrder:(Order *)order;

@end
