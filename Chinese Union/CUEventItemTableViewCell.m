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
    
    [[RACSignal combineLatest:@[RACObserve(viewModel, timeToEvent), RACObserve(viewModel, timeUnit)]] subscribeNext:^(RACTuple *x) {
        @strongify(self);
        NSNumber *timeToEvent = [x first];
        NSString *timeUnit = [x second];
        
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
        
        if ([timeUnit rangeOfString:@"day"].location != NSNotFound)
        {
            UIColor *dayColor = [UIColor colorWithRed:0.301 green:0.753 blue:0.576 alpha:1.000];
            self.timeUnitLabel.backgroundColor = dayColor;
            self.timeUnitLabelBig.backgroundColor = dayColor;
        }
        else if ([timeUnit rangeOfString:@"hour"].location != NSNotFound)
        {
            UIColor *dayColor = [UIColor colorWithRed:0.753 green:0.572 blue:0.315 alpha:1.000];
            self.timeUnitLabel.backgroundColor = dayColor;
            self.timeUnitLabelBig.backgroundColor = dayColor;
        }
        else if ([timeUnit rangeOfString:@"min"].location != NSNotFound &&
                 [timeUnit length] < 5)
        {
            UIColor *dayColor = [UIColor colorWithRed:1.000 green:0.333 blue:0.730 alpha:1.000];
            self.timeUnitLabel.backgroundColor = dayColor;
            self.timeUnitLabelBig.backgroundColor = dayColor;
        }
        else if ([timeUnit rangeOfString:@"Less than"].location != NSNotFound)
        {
            UIColor *dayColor = [UIColor redColor];
            self.timeUnitLabel.backgroundColor = dayColor;
            self.timeUnitLabelBig.backgroundColor = dayColor;
        }
        else if ([timeUnit rangeOfString:@"Expired"].location != NSNotFound)
        {
            UIColor *dayColor = [UIColor colorWithWhite:0.341 alpha:1.000];
            self.timeUnitLabel.backgroundColor = dayColor;
            self.timeUnitLabelBig.backgroundColor = dayColor;
        }
    }];
    
//    [RACObserve(viewModel, timeToEvent) subscribeNext:^(NSNumber *x) {
//        @strongify(self);
//        self.timeToEventLabel.text = [x stringValue];
//        [self.timeToEventButton setTitle:[x stringValue] forState:UIControlStateSelected];
//        [self.timeToEventButton sizeToFit];
//    }];
//    
//    [RACObserve(viewModel, timeUnit) subscribeNext:^(id x) {
//        @strongify(self);
//        if ([self.timeUnitLabel isKindOfClass:[CUInsetLabel class]])
//        {
//            if (viewModel.timeToEvent == nil)
//            {
//                ((CUInsetLabel *)self.timeUnitLabel).cornerOption = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerBottomLeft;
//            }
//            else
//            {
//                ((CUInsetLabel *)self.timeToEventLabel).cornerOption = UIRectCornerTopLeft | UIRectCornerBottomLeft;
//                ((CUInsetLabel *)self.timeUnitLabel).cornerOption = UIRectCornerTopRight | UIRectCornerBottomRight;
//            }
//        }
//        self.timeUnitLabel.text = [x copy];
//        [self.timeUnitButton setTitle:[x copy] forState:UIControlStateSelected];
//    }];
    
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
