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
#import "CUResizableTextView.h"

@interface CUEventItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CUInsetLabel *timeToEventLabel;
@property (weak, nonatomic) IBOutlet CUInsetLabel *timeUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
//@property (weak, nonatomic) IBOutlet UIButton *timeUnitButton;
//@property (weak, nonatomic) IBOutlet UIButton *timeToEventButton;
@property (weak, nonatomic) IBOutlet UILabel *timeToEventLabelBig;
@property (weak, nonatomic) IBOutlet CUInsetLabel *timeUnitLabelBig;
@property (weak, nonatomic) IBOutlet UILabel *eventDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandLabelConstraint;
@property (weak, nonatomic) IBOutlet UILabel *expandLabel;

@end

@implementation CUEventItemTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(18, 0, 18, 0);
    UIImage *backgroundImage = [UIImage imageNamed:@"EventCell"];
    backgroundImage = [backgroundImage resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = backgroundImage;
    self.backgroundView = imageView;
    
    UIImage *backgroundImageSelect = [UIImage imageNamed:@"EventCell"];
    backgroundImageSelect = [backgroundImageSelect resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    UIImageView *imageViewSelect = [[UIImageView alloc] initWithFrame:self.bounds];
    imageViewSelect.image = backgroundImageSelect;
    self.selectedBackgroundView = imageViewSelect;
}

- (void)bindViewModel:(CUEventItemViewModel *)viewModel
{
    @weakify(self);
    [RACObserve(viewModel, name) subscribeNext:^(NSString *x) {
        @strongify(self);
        self.titleLabel.text = [NSString stringWithFormat:@"%@", x];
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
        
        NSString *timeToEventString = [timeToEvent stringValue];
        self.timeToEventLabel.text = timeToEventString;
        self.timeToEventLabelBig.text = timeToEventString;
        self.timeUnitLabel.text = [timeUnit copy];
        self.timeUnitLabelBig.text = [timeUnit copy];
        self.timeUnitLabel.backgroundColor = color;
        self.timeUnitLabelBig.backgroundColor = color;
    }];
    
    [RACObserve(viewModel, eventDate) subscribeNext:^(id x) {
        @strongify(self);
        NSString *eventDateString = [NSString stringWithFormat:@"%@", [[NSDateFormatter eventDateFormatter] stringFromDate:x]];
        self.eventDateLabel.text = eventDateString;
    }];
    
    [RACObserve(viewModel, duration) subscribeNext:^(id x) {
        @strongify(self);
        NSString *eventDurationString = [NSString stringWithFormat:@"Duration: %@", x];
        self.eventDurationLabel.text = eventDurationString;
    }];
    
    [RACObserve(viewModel, location) subscribeNext:^(id x) {
        @strongify(self);
        NSString *eventLocationString = [NSString stringWithFormat:@"Location: %@", x];
        self.eventLocationLabel.text = eventLocationString;
    }];
    
    [RACObserve(viewModel, image) subscribeNext:^(id x) {
        @strongify(self);
        self.eventImageView.image = x;
    }];
    
    [RACObserve(viewModel, eventDescription) subscribeNext:^(id x) {
        @strongify(self);
        self.eventDescriptionLabel.text = x;
        
    }];
    
//    [RACObserve(viewModel, isExpanded) subscribeNext:^(id x) {
//        @strongify(self);
//        self.eventDescriptionTextView.isOriginal = ![x boolValue];
//    }];
    
    [RACObserve(viewModel, expandHintString) subscribeNext:^(id x) {
        @strongify(self);
        self.expandLabel.text = x;
    }];
    
    [RACObserve(viewModel, product) subscribeNext:^(id x) {
        @strongify(self);
        self.buyTicketButton.enabled = x != nil;
    }];
    
//    if (![self.eventDescriptionTextView hasMoreText]) {
//        @strongify(self);
//        self.expandLabelConstraint.constant = 0;
//    }
    
    viewModel.active = YES;
    [[self rac_prepareForReuseSignal] subscribeNext:^(id x) {
        viewModel.active = NO;
    }];
}

@end
