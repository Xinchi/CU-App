//
//  SubclassConfigViewController.h
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

@interface ProfileViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIActionSheetDelegate, ZBarReaderDelegate, UIAlertViewDelegate>

- (IBAction)logOutButtonTapAction:(id)sender;

@end
