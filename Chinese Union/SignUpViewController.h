//
//  SignUpViewController.h
//  Chinese Union
//
//  Created by Max Gu on 6/9/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CUSignUpViewControllerDelegate <NSObject>
@optional

/// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(UIViewController *)signUpController didSignUpUser:(PFUser *)user;

@end

@interface SignUpViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) id<CUSignUpViewControllerDelegate> delegate;

@end
