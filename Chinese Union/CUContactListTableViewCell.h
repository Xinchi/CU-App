//
//  CUContactListTableViewCell.h
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUContactListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *collegeLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;

@end
