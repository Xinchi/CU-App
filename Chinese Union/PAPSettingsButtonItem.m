//
//  PAPSettingsButtonItem.m
//  Anypic
//
//  Created by Héctor Ramos on 5/18/12.
//

#import "PAPSettingsButtonItem.h"

@implementation PAPSettingsButtonItem

#pragma mark - Initialization

- (id)initWithTarget:(id)target action:(SEL)action {
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];

    self = [super initWithCustomView:settingsButton];
    if (self) {
        [settingsButton setBackgroundImage:[UIImage imageNamed:@"buttonSettings"] forState:UIControlStateNormal];
        [settingsButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [settingsButton setFrame:CGRectMake(0.0f, 0.0f, 35.0f, 32.0f)];
        [settingsButton setImage:[UIImage imageNamed:@"buttonImageSettings"] forState:UIControlStateNormal];
        [settingsButton setImage:[UIImage imageNamed:@"buttonImageSettingsSelected"] forState:UIControlStateHighlighted];
    }
    
    return self;
}
@end
