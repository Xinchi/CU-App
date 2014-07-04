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
#import "NSString+Additions.h"

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
    NSLog(@"activateButtonPressed");
    NSString *memberID = self.memberIDTextField.text;
    
    if (![memberID cleanString].length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:@"Please fill in member ID" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    // Do activation here
    
    PFQuery *query = [PFQuery queryWithClassName:@"CUMembers"];
    [query getObjectInBackgroundWithId:memberID block:^(PFObject *object, NSError *error) {
        if(!error){
            if(object!=nil)
            {
                CUMembers *member = (CUMembers *)object;
                NSLog(@"Member ID Found!");
                if(member.uid !=nil)
                {
                    NSLog(@"The Member ID has already been activated! ");
                    //handle the already-activated case
                    [PFCloud callFunctionInBackground:@"activationFailResponse" withParameters:@{} block:^(NSString *result, NSError *error){
                        if(!error){
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooooops"
                                                                            message:result
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles: nil];
                            [alert show];
                        }
                    }];
                    
                } else {
                    self.user.CUMemberID = member.objectId;
                    [self.user saveInBackground];
                    member.uid = self.user.objectId;
                    [member saveInBackground];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                                    message:@"You have successfully activated your CU membership, thank you!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                    [alert show];
                }

            }
            else {
                NSLog(@"Invalid Member ID Entered! No matching found!");
            }
        }
        else {
            NSLog(@"Error: %@ %@",error,[error userInfo]);
        }
    }];
}

- (IBAction)purchaseMemberButtonPressed:(id)sender {
}

- (IBAction)viewTapped:(id)sender {
    [self.memberIDTextField resignFirstResponder];
    

}

@end
