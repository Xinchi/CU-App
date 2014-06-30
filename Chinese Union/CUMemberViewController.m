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
#import "CUMembers.h"

@interface CUMemberViewController ()

@property (retain) User *user;
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
    self.user = [User currentUser];
    
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
    if(self.user.CUMemberID != nil)
    {
        return true;
    }
    return false;
}

- (IBAction)activateButtonPressed:(id)sender {
    NSString *memberID = self.memberIDTextField.text;
    
    // Do activation here
}

- (IBAction)purchaseMemberButtonPressed:(id)sender {
}

- (IBAction)viewTapped:(id)sender {
    [self.memberIDTextField resignFirstResponder];
    
    PFQuery *query = [PFQuery queryWithClassName:@"CUMembers"];
    [query whereKey:@"ID" equalTo:[self.memberIDTextField text]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            if(objects.count==1)
            {
                NSLog(@"Member ID Found!");
                self.user.CUMemberID = ((CUMembers *)objects[0]).objectId;
                ((CUMembers *)objects[0]).uid = self.user.objectId;
            }
        }
        else {
            NSLog(@"Error: %@ %@",error,[error userInfo]);
        }
    }];
}

@end
