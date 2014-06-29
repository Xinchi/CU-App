//
//  CUMemberViewController.m
//  Chinese Union
//
//  Created by Max Gu on 6/29/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUMemberViewController.h"
#import "User.h"
#import "UIViewController+Additions.h"

@interface CUMemberViewController ()

@property (weak, nonatomic) IBOutlet UIView *notMemberView;
@property (weak, nonatomic) IBOutlet UITextField *memberIDTextField;
@property (weak, nonatomic) IBOutlet UIImageView *upperImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lowerImageView;

@end

@implementation CUMemberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"Member?%@", [self isAMember] ? @"YES" : @"NO");
    
    self.title = @"Member";
    
    [self addExitButton];    
    
    UIImage *backgroundImage = [UIImage imageNamed:@"Product.png"];
    UIEdgeInsets backgroundInsets = UIEdgeInsetsMake(backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f, backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f);\
    backgroundImage = [backgroundImage resizableImageWithCapInsets:backgroundInsets];

    self.upperImageView.image = backgroundImage;
    self.lowerImageView.image = backgroundImage;
    
//    self.notMemberView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blur_White"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.notMemberView.hidden = [self isAMember];
}

- (bool)isAMember
{
    User *user = [User currentUser];
    if(user.CUMemberID != nil)
    {
        return true;
    }
    return false;
}

- (IBAction)purchaseMemberButtonPressed:(id)sender {
}

- (IBAction)viewTapped:(id)sender {
    [self.memberIDTextField resignFirstResponder];
}

@end
