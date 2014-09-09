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
#import "CUInsetLabel.h"

@interface CUEventItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CUInsetLabel *timeToEventLabel;
@property (weak, nonatomic) IBOutlet CUInsetLabel *timeUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
//@property (weak, nonatomic) IBOutlet UIButton *timeUnitButton;
//@property (weak, nonatomic) IBOutlet UIButton *timeToEventButton;
@property (weak, nonatomic) IBOutlet UILabel *timeToEventLabelBig;
@property (weak, nonatomic) IBOutlet CUInsetLabel *timeUnitLabelBig;

@end

@implementation CUEventItemTableViewCell

- (void)bindViewModel:(CUEventItemViewModel *)viewModel
{
    @weakify(self);
    [RACObserve(viewModel, name) subscribeNext:^(NSString *x) {
        @strongify(self);
        self.titleLabel.text = [NSString stringWithFormat:@"Time till %@", x];
    }];
    
    [[RACSignal combineLatest:@[RACObserve(viewModel, timeToEvent),
                                RACObserve(viewModel, timeUnit),
                                RACObserve(viewModel, timeUnitColor)]
      ] subscribeNext:^(RACTuple *x) {
        @strongify(self);
        NSNumber *timeToEvent = [x first];
        NSString *timeUnit = [x second];
        UIColor *color = [x third];
        
        if (timeToEvent == nil)
        {
            ((CUInsetLabel *)self.timeUnitLabel).cornerOption = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerBottomLeft;
        }
        else
        {
            ((CUInsetLabel *)self.timeToEventLabel).cornerOption = UIRectCornerTopLeft | UIRectCornerBottomLeft;
            ((CUInsetLabel *)self.timeUnitLabel).cornerOption = UIRectCornerTopRight | UIRectCornerBottomRight;
        }
        
        self.timeToEventLabel.text = [timeToEvent stringValue];
        self.timeToEventLabelBig.text = [timeToEvent stringValue];
        self.timeUnitLabel.text = [timeUnit copy];
        self.timeUnitLabelBig.text = [timeUnit copy];
        self.timeUnitLabel.backgroundColor = color;
        self.timeUnitLabelBig.backgroundColor = color;
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
