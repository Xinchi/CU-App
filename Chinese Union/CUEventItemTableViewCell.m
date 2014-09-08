//
//  CUEventItemTableViewCell.m
//  Chinese Union
//
//  Created by wpliao on 9/7/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUEventItemTableViewCell.h"
#import "CUEventItemViewModel.h"

@interface CUEventItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeToEventLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeUnitLabel;

@end

@implementation CUEventItemTableViewCell

- (void)bindViewModel:(CUEventItemViewModel *)viewModel
{
    @weakify(self);
    [RACObserve(viewModel, name) subscribeNext:^(NSString *x) {
        @strongify(self);
        self.titleLabel.text = [NSString stringWithFormat:@"Time till %@", x];
    }];
    
    [RACObserve(viewModel, timeToEvent) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.timeToEventLabel.text = [x stringValue];
    }];
    
    [RACObserve(viewModel, timeUnit) subscribeNext:^(id x) {
        @strongify(self);
        self.timeUnitLabel.text = [x copy];
    }];
    
    viewModel.active = YES;
    [[self rac_prepareForReuseSignal] subscribeNext:^(id x) {
        viewModel.active = NO;
    }];
}

@end
