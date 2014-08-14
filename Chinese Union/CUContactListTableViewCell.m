//
//  CUContactListTableViewCell.m
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUContactListTableViewCell.h"

@implementation CUContactListTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.profilePicImageView.layer.cornerRadius = 8;
    self.profilePicImageView.layer.masksToBounds = YES;
    self.profilePicImageView.layer.borderWidth = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
