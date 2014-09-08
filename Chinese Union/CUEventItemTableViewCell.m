//
//  CUEventItemTableViewCell.m
//  Chinese Union
//
//  Created by wpliao on 9/7/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUEventItemTableViewCell.h"
#import "CUEventItemViewModel.h"
#import "NSDateFormatter+Additions.h"

@interface CUEventItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeToEventLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeUnitButton;
@property (weak, nonatomic) IBOutlet UIButton *timeToEventButton;

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
        [self.timeToEventButton setTitle:[x stringValue] forState:UIControlStateSelected];
        [self.timeToEventButton sizeToFit];
    }];
    
    [RACObserve(viewModel, timeUnit) subscribeNext:^(id x) {
        @strongify(self);
        self.timeUnitLabel.text = [x copy];
        [self.timeUnitButton setTitle:[x copy] forState:UIControlStateSelected];
    }];
    
    [RACObserve(viewModel, eventDate) subscribeNext:^(id x) {
        @strongify(self);
        self.eventDateLabel.text = [[NSDateFormatter eventDateFormatter] stringFromDate:x];
    }];
    
    viewModel.active = YES;
    [[self rac_prepareForReuseSignal] subscribeNext:^(id x) {
        viewModel.active = NO;
    }];
}

@end
