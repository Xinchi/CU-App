//
//  FBCallBack.m
//  Chinese Union
//
//  Created by Max Gu on 9/25/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "FBCallBack.h"
#import "User.h"

@implementation FBCallBack


#pragma mark - PF_FBRequestDelegate
- (void)FBrequestdidLoad:(id)result {
    // This method is called twice - once for the user's /me profile, and a second time when obtaining their friends. We will try and handle both scenarios in a single method.
    MyLog(@"FBrequestdidLoad delegate");
    
    MyLog(@"In FBrequestdidLoad, the result passed in = %@", result);
    NSArray *data = [result objectForKey:@"data"];
    
    if (data) {
        // we have friends data
        MyLog(@"We have friends data here!");
        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (NSDictionary *friendData in data) {
            [facebookIds addObject:[friendData objectForKey:@"id"]];
            MyLog(@"Friend fb id = %@",[friendData objectForKey:@"id"]);
        }
        
        // cache friend data
        [[PAPCache sharedCache] setFacebookFriends:facebookIds];
        
        if (![[User currentUser] objectForKey:kPAPUserAlreadyAutoFollowedFacebookFriendsKey]) {
            
            //            [self.hud setLabelText:@"Following Friends"];
            //            NSLog(@"Auto-following");
            //            firstLaunch = YES;
            [_delegate setHud:@"Following Friends"];
            [_delegate setFirstLaunchField:YES];
            
            [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES] forKey:kPAPUserAlreadyAutoFollowedFacebookFriendsKey];
            NSError *error = nil;
            
            // find common Facebook friends already using Anypic
            PFQuery *facebookFriendsQuery = [User query];
            [facebookFriendsQuery whereKey:kPAPUserFacebookIDKey containedIn:facebookIds];
            
            NSArray *anypicFriends = [facebookFriendsQuery findObjects:&error];
            if (!error) {
                [anypicFriends enumerateObjectsUsingBlock:^(User *newFriend, NSUInteger idx, BOOL *stop) {
                    NSLog(@"Join activity for %@", [newFriend objectForKey:kPAPUserDisplayNameKey]);
                    PFObject *joinActivity = [PFObject objectWithClassName:kPAPActivityClassKey];
                    [joinActivity setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey];
                    [joinActivity setObject:newFriend forKey:kPAPActivityToUserKey];
                    [joinActivity setObject:kPAPActivityTypeJoined forKey:kPAPActivityTypeKey];
                    
                    PFACL *joinACL = [PFACL ACL];
                    [joinACL setPublicReadAccess:YES];
                    joinActivity.ACL = joinACL;
                    
                    // make sure our join activity is always earlier than a follow
                    [joinActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"Followed %@", [newFriend objectForKey:kPAPUserDisplayNameKey]);
                        }
                        
                        [PAPUtility followUserInBackground:newFriend block:^(BOOL succeeded, NSError *error) {
                            // This block will be executed once for each friend that is followed.
                            // We need to refresh the timeline when we are following at least a few friends
                            // Use a timer to avoid refreshing innecessarily
                            [_delegate setAutoFollowTimer];
                        }];
                    }];
                }];
            }
            

            
            if (!error) {
//                [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:NO];
//                self.hud = [MBProgressHUD showHUDAddedTo:self.homeViewController.view animated:NO];
//                [self.hud setDimBackground:YES];
//                [self.hud setLabelText:@"Following Friends"];
                [_delegate handleFollowingFriends];
            }
        }
        
        [[User currentUser] saveEventually];
    } else {
//        [self.hud setLabelText:@"Creating Profile"];
        [_delegate setHud:@"Creating Profile"];
        NSString *facebookId = [result objectForKey:@"id"];
        NSString *facebookName = [result objectForKey:@"name"];
        
        //we don't need to override the username
//        if (facebookName && facebookName != 0) {
//            [[User currentUser] setObject:facebookName forKey:kPAPUserDisplayNameKey];
//        }
        
        if (facebookId && facebookId != 0) {
            [[User currentUser] setObject:facebookId forKey:kPAPUserFacebookIDKey];
        }
//        [[PFFacebookUtils facebook] requestWithGraphPath:@"me/friends" andDelegate:self];
        [FBRequestConnection startWithGraphPath:@"me/friends" completionHandler:^(FBRequestConnection *connection, id result, NSError*error){
            if(!error)
            {
                [self FBrequestdidLoad:result];
            } else {
                MyLog(@"FB Gragh me/friends failed");
                [self FBrequestDidFailWithError:error];
            }
        }];
        
    }
}

- (void)FBrequestDidFailWithError:(NSError *)error {
    NSLog(@"Facebook error: %@", error);
    
    if ([User currentUser]) {
        if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
             isEqualToString: @"OAuthException"]) {
            NSLog(@"The facebook token was invalidated");
//            [self logOut];
        }
    }
}



@end
