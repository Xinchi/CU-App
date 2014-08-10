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
#import "MBProgressHUD.h"
#import "QRGenerator.h"
#import "MRProgress.h"
#import "NSDateFormatter+Additions.h"
#import "QRGenerator.h"
#import "PFProductsViewController.h"

@interface CUMemberViewController ()

@property (retain) User *user;
@property CUMembers *cuMember;
@property (weak, nonatomic) IBOutlet UIView *notMemberView;
@property (weak, nonatomic) IBOutlet UIView *memberView;
@property (weak, nonatomic) IBOutlet UITextField *memberIDTextField;
@property (weak, nonatomic) IBOutlet UIImageView *upperImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lowerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRcodeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *memberCardBackgroundImageView;

@end

@implementation CUMemberViewController

- (void)viewDidLoad
{
    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"loading..." mode:MRProgressOverlayViewModeIndeterminateSmall animated:NO];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [hud setLabelText:@"Loading..."];
//    hud.opacity = 0.5;
//    hud.dimBackground = YES;
    
//    hud.mode = MBProgressHUDModeDeterminate;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"Member";
    
    self.memberView.hidden = YES;
    self.notMemberView.hidden = YES;
    [self addExitButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

    self.user = [User currentUser];
    
    [self.user refresh];
    
    if([self isAMember])
    {
        
        //get member object
        PFQuery *query = [PFQuery queryWithClassName:@"CUMembers"];
        [query whereKey:@"uid" equalTo:self.user.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error && [objects count]==1)
            {
                _cuMember = (CUMembers *)objects[0];
                MyLog(@"Get member record! Expire date = %@",_cuMember.expireDate);
            }else if(error){
                // Log details of the failure
                MyLog(@"Error: %@ %@", error, [error userInfo]);
            }else
            {
                MyLog(@"Error !More than one member record has been found!");
            }
            [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:NO];
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self updateMemberView];
        }];
    }
    [self updateMemberView];
    [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MRProgressOverlayView dismissAllOverlaysForView:self.profileViewController.view animated:YES];
}
- (void)updateMemberView {
    self.notMemberView.hidden = [self isAMember];
    self.memberView.hidden    = ![self isAMember];
    
    if ([self isAMember]) {
        self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
        self.memberIDLabel.text = self.user.CUMemberID;
        self.expireDateLabel.text = [[NSDateFormatter birthdayFormatter] stringFromDate:self.cuMember.expireDate];
        NSData *imageData = [self.user.profilePic getData];
        UIImage *profileImage = [UIImage imageWithData:imageData];
        self.userPicImageView.image = profileImage;
        self.userPicImageView.layer.cornerRadius = 8;
        self.userPicImageView.layer.masksToBounds = YES;
        self.userPicImageView.layer.borderWidth = 0;
        self.QRcodeImageView.image =  [QRGenerator QRImageWithSize:self.QRcodeImageView.frame.size.width  fillColor:[UIColor darkGrayColor]];;
        
        UIImage *backgroundImage = [UIImage imageNamed:@"Product.png"];
        UIEdgeInsets backgroundInsets = UIEdgeInsetsMake(backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f, backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f);
        backgroundImage = [backgroundImage resizableImageWithCapInsets:backgroundInsets];
        self.memberCardBackgroundImageView.image = backgroundImage;
    }
    else {
        UIImage *backgroundImage = [UIImage imageNamed:@"Product.png"];
        UIEdgeInsets backgroundInsets = UIEdgeInsetsMake(backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f, backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f);
        backgroundImage = [backgroundImage resizableImageWithCapInsets:backgroundInsets];
        
        self.upperImageView.image = backgroundImage;
        self.lowerImageView.image = backgroundImage;
    }
    MyLog(@"DONE WITH updateMemberView");
}

- (bool)isAMember
{

    if(self.user.CUMemberID != nil)
    {
        MyLog(@"Member ID is ? = %@",self.user.CUMemberID);
        return true;
    }
    else
    {
        MyLog(@"Not a member!");
    }
    return false;
}

- (IBAction)activateButtonPressed:(id)sender {
    MyLog(@"activateButtonPressed");
    NSString *memberID = self.memberIDTextField.text;
    
    if (![memberID cleanString].length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:@"Please fill in member ID" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    // Do activation here
    [self.memberIDTextField resignFirstResponder];
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view animated:YES];

    PFQuery *query = [PFQuery queryWithClassName:@"CUMembers"];
    [query getObjectInBackgroundWithId:memberID block:^(PFObject *object, NSError *error) {
        if(!error){

            CUMembers *member = (CUMembers *)object;
        
            MyLog(@"Member ID Found!");
            if(member.uid !=nil)
            {
                MyLog(@"The Member ID has already been activated!");
                //handle the already-activated case
                [PFCloud callFunctionInBackground:@"activationFailResponse" withParameters:@{} block:^(NSString *result, NSError *error){
                    if(!error){
                        [self showAlertTitle:NSLocalizedString(@"Error", @"")
                                         msg:result];
                    }
                }];
                
            } else {

                //update expire date
                [PFCloud callFunctionInBackground:@"getTime" withParameters:@{} block:^(NSDate *result, NSError *error){
                    if(!error){
                        NSDate *date = result;
                        MyLog(@"Todays date is %@",date);
                        NSDateComponents *components = [[NSDateComponents alloc] init];
                        [PFCloud callFunctionInBackground:@"memberShipCycle" withParameters:@{} block:^(NSString *result, NSError *error){
                            if(!error){
                                components.month = [result integerValue];
                                NSDate *expire = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
                                MyLog(@"Expire date is %@", expire);
                                member.expireDate = expire;
                                self.user.CUMemberID = member.objectId;
                                [self.user saveInBackground];
                                member.uid = self.user.objectId;
                                [member saveInBackground];
                                [self updateMemberView];
                            }
                        }];
                    }
                }];
                [PFCloud callFunctionInBackground:@"activationSuccessResponse" withParameters:@{} block:^(NSString *result, NSError *error){
                    if(!error){
                        [self showAlertTitle:NSLocalizedString(@"Congratulations!", @"")
                                 msg:result];
                    }
                }];

                
            }

        }
        else {
            MyLog(@"Invalid Member ID Entered! No matching found!");
            [PFCloud callFunctionInBackground:@"invalidMemberId" withParameters:@{} block:^(NSString *result, NSError *error){
                if(!error){
                    [self showAlertTitle:NSLocalizedString(@"Error", @"")
                                     msg:result];
                }
            }];
        }
        [self updateMemberView];
    }];
}

- (void)showAlertTitle:(NSString *)title msg:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
//    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    [MRProgressOverlayView dismissAllOverlaysForView:self.navigationController.view animated:YES];
}

- (IBAction)purchaseMemberButtonPressed:(id)sender {
    PFProductsViewController *storeVC = [[PFProductsViewController alloc] init];
    storeVC.shouldAddExitButton = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:storeVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)viewTapped:(id)sender {
    [self.memberIDTextField resignFirstResponder];
}

@end
