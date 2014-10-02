//
//  CULoginViewController.m
//  Chinese Union
//
//  Created by wpliao on 2014/6/14.
//  Copyright (c) 2014年 ucsd.ChineseUnion. All rights reserved.
//

#import "CULoginViewController.h"
#import "SignUpViewController.h"
#import "User.h"
#import "UIViewController+Additions.h"
#import "MBProgressHUD.h"
#import "MRProgress.h"
#import "CUForgotPasswordViewController.h"
#import "User.h"
#import "ServiceCallManager.h"
#import "Constants.h"
#import "FBCallBack.h"
#import "Common.h"

@interface CULoginViewController ()

@property (weak, nonatomic) UIResponder *activeResponder;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGR;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation CULoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Login";

    [self addExitButton];
    
    [self.view addGestureRecognizer:self.tapGR];
    
    self.userNameTextField.layer.opacity = 0.9;
    self.passwordTextField.layer.opacity = 0.9;
    
    [self addBorderToButton:self.fbButton];
    [self addBorderToButton:self.twitterButton];
    [self addBorderToButton:self.signupButton];
    [self addBorderToButton:self.forgotPasswordButton];
    
    [self bindViewModel];
}

- (void)bindViewModel
{
    RACSignal *loginEnabledSignal = [RACSignal
                                     combineLatest:@[self.userNameTextField.rac_textSignal,
                                                     self.passwordTextField.rac_textSignal]
                                     reduce:^(NSString *username, NSString *password){
                                         return @(username.length > 0 && password.length > 0);
                                     }];
    
    RACSignal *loginSignal = [self loginSignal];
    loginSignal = [[[[loginSignal initially:^{
        [self.activeResponder resignFirstResponder];
        [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    }] doCompleted:^{
        [self loginSucceeded];
    }] doError:^(NSError *error) {
        [self loginFailedWithError:error];
    }] finally:^{
        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
    }];
    
    RACCommand *loginCommand = [[RACCommand alloc] initWithEnabled:loginEnabledSignal signalBlock:^RACSignal *(id input) {
        return loginSignal;
    }];
    
    self.loginButton.rac_command = loginCommand;
}

- (IBAction)signUpButtonPressed:(id)sender {
    SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signUpVC];
    signUpVC.delegate = self.delegate;
    MyLog(@"Delegate:%@", signUpVC.delegate);
    [self presentViewController:nav animated:YES completion:nil];
}

- (RACSignal *)loginSignal
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [ServiceCallManager
         logInWithUsernameInBackground:self.userNameTextField.text
         password:self.passwordTextField.text
         block:^(PFUser *user, NSError *error){
             if (error) {
                 [subscriber sendError:error];
             }
             else {
                 [subscriber sendNext:user];
                 [subscriber sendCompleted];
             }
        }];
        return nil;
    }];
}

- (void) loginFailedWithError: (NSError *)error
{
    [ServiceCallManager callFunctionInBackground:@"loginFail" withParameters:@{} block:^(NSString *result, NSError *error){
        if(!error){
            [self showAlertTitle:NSLocalizedString(@"Error", @"")
                             msg:result];
        }
    }];
}

- (void) loginSucceeded
{
    MyLog(@"Login Succeeded!");
    [ServiceCallManager callFunctionInBackground:@"loginSuccessful" withParameters:@{} block:^(NSString *result, NSError *error){
        if(!error){

            [self subscribeToPrivateChannelForFacebookUser:NO];
            [self showAlertTitle:NSLocalizedString(@"Success!", @"")
                             msg:result];
            [self dismissViewControllerAnimated:YES completion:nil];

        }
    }];
}

-(void) subscribeToPrivateChannelForFacebookUser:(BOOL)facebookUser
{
    // Subscribe to private push channel
    User *user = [User currentUser];
    if (user) {
        NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user objectId]];
        [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:kPAPInstallationUserKey];
        [[PFInstallation currentInstallation] addUniqueObject:privateChannelName forKey:kPAPInstallationChannelsKey];
        [[PFInstallation currentInstallation] saveEventually];
        [user setObject:privateChannelName forKey:kPAPUserPrivateChannelKey];
        if(!facebookUser)
            [user saveInBackground];
    }
}

- (IBAction)viewTapped:(id)sender {
    [self.activeResponder resignFirstResponder];
}

#pragma mark - Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeResponder = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self.loginButton.rac_command execute:nil];
    }
    return YES;
}

- (void)showAlertTitle:(NSString *)title msg:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
}

#pragma mark - IBActions

- (IBAction)forgotPasswordButtonPressed:(UIButton *)sender {
    CUForgotPasswordViewController *vc = [[CUForgotPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)fbButtonPressed:(UIButton *)sender {
    BOOL syncFromFBAllowedByUser = YES;

    [MRProgressOverlayView showOverlayAddedTo:self.view title:@"Logging in..." mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    MyLog(@"FB button!");
    
    NSArray *permissions = [NSArray arrayWithObjects:PUBLIC_PROFILE,EMAIL, USER_BIRTHDAY,USER_FRIENDS, nil];
    
    
     
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        
        
        if(error){
            MyLog(@"Error: %@",error);
            [Common showAlertTitle:@"Login Failed" msg:[Common getUsefulErrorMessage:error] onView:self.view];
        }else if (!user) {
            MyLog(@"Uh oh. The user cancelled the Facebook login.");
            [self showAlertTitle:@"Login fail" msg:@"Please check Settings->Facebook and make sure the the toggle for Chinese Union is on"];
        } else {
            
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                FBCallBack *fbCallBack = [[FBCallBack alloc] init];
                if (!error) {
                    // Success! Include your code to handle the results here
                    NSDictionary *userInfo = result;
                    NSLog(@"user info: %@", [userInfo description]);
                    
                    // Subscribe to private push channel
                    [self subscribeToPrivateChannelForFacebookUser:YES];
                    
                    //
                    if(syncFromFBAllowedByUser)
                    {
                        [self updateUserWithDictionary:result withUser:user newUser:user.isNew];
                    }
                    else
                    {
                        [self showAlertTitle:@"Welcome back!" msg:@"Info not synced from facebook!"];
                    }
                    
                    
                    //FBCallBackToRefreshFriendsList/Get FB ID
                    MyLog(@"About to call fbCallBack");
                    [fbCallBack FBrequestdidLoad:result];
                    
                } else {
                    MyLog(@"### ERROR: %@",error);
                    // An error occurred, we need to handle the error
                    // See: https://developers.facebook.com/docs/ios/errors
                    [fbCallBack FBrequestDidFailWithError:error];
                }
            }];
            
            // Check for publish permissions
            [FBRequestConnection startWithGraphPath:@"/me/permissions"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error){
                                          NSDictionary *permissions= result;
//                                          MyLog(@"permissions = %@",permissions);
                                      } else {
                                          // There was an error, handle it
                                          // See https://developers.facebook.com/docs/ios/errors/
                                      }
            }];
//            [FBRequestConnection startWithGraphPath:@"me/friends" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                FBCallBack *fbCallBack;
//                if (!error) {
//                    NSDictionary *friends= result;
//                    MyLog(@"friends = %@",friends);
//                    if(fbCallBack == nil)
//                    {
//                        fbCallBack = [[FBCallBack alloc] init];
//                    }
//                    [fbCallBack FBrequestdidLoad:result];
//                } else {
//                    [fbCallBack FBrequestDidFailWithError:error];
//                }
//            }];
        }
    }];
}

- (void) updateUserWithDictionary:(NSDictionary *)userInfo withUser: (PFUser *)user newUser:(BOOL)isNewUser
{
    User *currentUser = (User *)user;
//    currentUser.objectId = userInfo[@"email"];
    if(isNewUser)
    {
        currentUser.username = userInfo[FB_USER_EMAIL];
        
        //check if email existed already
        
        if([ServiceCallManager checkIfEmailExisted:userInfo[FB_USER_EMAIL]])
        {
            [ServiceCallManager logOutAndDeleteCurrentUserAccountWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded) {
                    [self showAlertTitle:@"Error" msg:@"The email has been registered before.  Please log in using that account"];
                    return;
                }else {
                    MyLog(@"error calling logOutAndDeleteCurrentUserAccountWithBlock = %@",[error userInfo][@"error]"]);
                }
            }];
        }
        //check if username existed already
        if([ServiceCallManager checkIfUsernameExisted:userInfo[FB_USER_FIRST_NAME]])
        {
            [ServiceCallManager logOutAndDeleteCurrentUserAccountWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded) {
                    [self showAlertTitle:@"Error" msg:@"The username has been registered before.  Please log in using that account"];
                    return;
                }else {
                    MyLog(@"error calling logOutAndDeleteCurrentUserAccountWithBlock = %@",[error userInfo][@"error]"]);
                }
            }];
        }

    }
    currentUser.firstName = userInfo[FB_USER_FIRST_NAME];
    currentUser.lastName = userInfo[FB_USER_LAST_NAME];
    currentUser.displayName = [NSString stringWithFormat:@"%@ %@",currentUser.firstName, currentUser.lastName];
    currentUser.email = userInfo[FB_USER_EMAIL];
    currentUser.gender = userInfo[FB_USER_GENDER];
    currentUser.facebookId = userInfo[FB_USER_ID];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    MyLog(@"User birthday = %@",userInfo[FB_USER_BIRTHDAY]);
    currentUser.birthday = [formatter dateFromString:userInfo[FB_USER_BIRTHDAY]];
    MyLog(@"curretUser.birthday = %@",currentUser.birthday);
    MyLog(@"formatter NSDate = %@",[formatter dateFromString:userInfo[@"birthday"]]);
    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:FB_USER_PROFILE_IMAGE_BASE_URL, userInfo[FB_USER_ID]]];
    NSData *imageData = [NSData dataWithContentsOfURL:pictureURL];
    PFFile *imageFile = [PFFile fileWithData:imageData];
    currentUser.profilePic = imageFile;
    currentUser.profilePictureMedium = imageFile;
    currentUser.profilePictureSmall = imageFile;
    
    NSLog(@"About to updateSerInfoWithUser");
    [ServiceCallManager updateUserInfoWithUser:currentUser WithBlock:^(BOOL succeeded, NSError *error){
       if(!error)
       {
           [self dismissViewControllerAnimated:YES completion:nil];

           if(isNewUser)
           {
               MyLog(@"Save new fb user successfully!");
               [self showAlertTitle:@"Welcome!" msg:@"New facebook user successfully registered, welcome to Chinese Union!"];
           }
           else
           {
               MyLog(@"Old fb user logged in!");
               [self showAlertTitle:@"Welcome back!" msg:@"Good to see you again!"];
           }
           
       }
       else{
           NSError *updateUserInfoError = error;
           MyLog(@"Error !!! : %@",updateUserInfoError);
           [ServiceCallManager logOutAndDeleteCurrentUserAccountWithBlock:^(BOOL succeeded, NSError *error) {
               if(succeeded) {
                   [self showAlertTitle:@"Opps" msg:[updateUserInfoError userInfo][@"error"]];
               }else {
                   MyLog(@"error calling logOutAndDeleteCurrentUserAccountWithBlock = %@",[error userInfo][@"error]"]);
               }
           }];
           
       }
    }];
}


- (IBAction)twitterButtonPressed:(UIButton *)sender {
    MyLog(@"Twitter button!");
}

@end
