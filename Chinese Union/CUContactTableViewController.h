//
//  CUTeamTableViewController.h
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface CUContactTableViewController : UITableViewController

@property (nonatomic) ObjectType contactType;
@property (strong, nonatomic) NSString *batch;

@end
