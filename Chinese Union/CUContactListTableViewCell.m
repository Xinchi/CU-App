//
//  CUContactListTableViewCell.m
//  Chinese Union
//
//  Created by wpliao on 8/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUContactListTableViewCell.h"
#import "CUInsetLabel.h"

@implementation CUContactListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    self.profilePicImageView.layer.cornerRadius = 8;
    self.profilePicImageView.layer.masksToBounds = YES;
    self.profilePicImageView.layer.borderWidth = 0;
    
    ((CUInsetLabel *)self.roleLabel).cornerOption = UIRectCornerAllCorners;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.roleLabel sizeToFit];
}

@end
