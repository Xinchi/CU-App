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
#import "Constants.h"
#import "ServiceCallManager.h"
#import "CUProducts.h"
#import "Common.h"
#import "PFShippingViewController.h"
#import "CUNavigationController.h"

@interface CUMemberViewController ()

@property (retain) User *user;
//@property CUMembers *cuMember;
@property __block CUProducts *membershipProduct;
@property (retain) CUProducts *memberProduct;
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
    [self updateMemberView];
    [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MRProgressOverlayView dismissAllOverlaysForView:self.profileViewController.view animated:YES];
}
- (void)updateMemberView {
    BOOL isAMember = [self isAMember];
    self.notMemberView.hidden = isAMember;
    self.memberView.hidden    = !isAMember;
    
    if (isAMember) {
        [self.user.cuMember fetchIfNeeded];
        self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
        self.memberIDLabel.text = self.user.cuMember.objectId;
        MyLog(@"Membership Expire Date = %@",self.user.cuMember.expireDate);
        self.expireDateLabel.text = [[NSDateFormatter birthdayFormatter] stringFromDate:self.user.cuMember.expireDate];
        NSData *imageData = [self.user.profilePic getData];
        UIImage *profileImage = [UIImage imageWithData:imageData];
        self.userPicImageView.image = profileImage;
        self.userPicImageView.layer.cornerRadius = 8;
        self.userPicImageView.layer.masksToBounds = YES;
        self.userPicImageView.layer.borderWidth = 0;
        self.QRcodeImageView.image = [Common generateQRCodeWithData:[NSString stringWithFormat:@"user_%@", self.user.objectId] withSize:self.QRcodeImageView.frame.size.width withFillColor:[UIColor darkGrayColor]];
        
        UIImage *backgroundImage = [UIImage imageNamed:@"Product.png"];
        UIEdgeInsets backgroundInsets = UIEdgeInsetsMake(backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f, backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f);
        backgroundImage = [backgroundImage resizableImageWithCapInsets:backgroundInsets];
        self.memberCardBackgroundImageView.image = backgroundImage;
    }
    else {
        
        UIImage *backgroundImage = [UIImage imageNamed:@"Product.png"];
        UIEdgeInsets backgroundInsets = UIEdgeInsetsMake(backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f, backgroundImage.size.height/2.0f, backgroundImage.size.width/2.0f);
        backgroundImage = [backgroundImage resizableImageWithCapInsets:backgroundInsets];
        PFQuery *query = [CUProducts query];
        [query getObjectInBackgroundWithId:CUMemberObjectID block:^(PFObject *object, NSError *error) {
            _membershipProduct = (CUProducts *)object;
        }];
        
        self.upperImageView.image = backgroundImage;
        self.lowerImageView.image = backgroundImage;
    }
    MyLog(@"DONE WITH updateMemberView");
}

- (bool)isAMember
{

    [ServiceCallManager getCurrentUser];
    if(self.user.cuMember != nil)
    {
        MyLog(@"Member ID is ? = %@",self.user.cuMember.objectId);
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
            if(member.memberUser !=nil)
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
                if(!STATIC_MEMBERSHIP_ENDING_DATE)
                {
                    [ServiceCallManager getCurrentDateWithBlock:^(NSDate *date, NSError *error) {
                        if(!error){
                            MyLog(@"Todays date is %@",date);
                            NSDateComponents *components = [[NSDateComponents alloc] init];
                            [PFCloud callFunctionInBackground:@"memberShipCycle" withParameters:@{} block:^(NSString *result, NSError *error){
                                if(!error){
                                    components.month = [result integerValue];
                                    NSDate *expire = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
                                    MyLog(@"Expire date is %@", expire);
                                    member.expireDate = expire;
                                    self.user.cuMember = member;
                                    [self.user saveInBackground];
                                    member.memberUser = self.user;
                                    [member saveInBackground];
                                    [self updateMemberView];
                                }
                            }];
                        }
                    }];
                } else {
                    [PFCloud callFunctionInBackground:CloudFunctionGetStaticMembershipExpirationDate withParameters:@{} block:^(NSDate *result, NSError *error){
                        if(!error){
                            NSDate *expire = result;
                            member.expireDate = expire;
                            self.user.cuMember = member;
                            [self.user saveInBackground];
                            member.memberUser = [ServiceCallManager getCurrentUser];
                            MyLog(@"Current member user id = %@", member.memberUser.objectId);
                            [member saveInBackground];
                            [self updateMemberView];
                        }
                    }];
                }

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

    PFShippingViewController *shippingViewController;
    if(_membershipProduct != nil)
    {
        shippingViewController = [[PFShippingViewController alloc] initWithProduct:_membershipProduct size:nil];
    }
    
    shippingViewController.shouldAddExitButton = YES;
    
    CUNavigationController *nav = [[CUNavigationController alloc] initWithRootViewController:shippingViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)viewTapped:(id)sender {
    [self.memberIDTextField resignFirstResponder];
}

@end
