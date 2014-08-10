//
//  ParseServiceManager.m
//  Chinese Union
//
//  Created by Max Gu on 8/10/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "ServiceCallManager.h"
#import "User.h"

@implementation ServiceCallManager

+ (ServiceCallManager *)manager
{
    static ServiceCallManager *sharedInstance;
    @synchronized(self) {
        if(!sharedInstance) {
            sharedInstance = [[ServiceCallManager alloc] init];
        }
    }
    return sharedInstance;
}



+ (void)callFunctionInBackground:(NSString *)function withParameters:(NSDictionary *)parameters block:(PFIdResultBlock)block
{
    [PFCloud callFunctionInBackground:function withParameters:parameters block:^(NSString *result, NSError *error){
        block(result,error);
    }];
}

+ (void)signUpInBackgroundWithUser: (User *)user WithBlock:(PFBooleanResultBlock)block
{
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        block(succeeded,error);
    }];
}

+ (void)logInWithUsernameInBackground:(NSString *)username
                             password:(NSString *)password
                                block:(PFUserResultBlock)block
{
    [User logInWithUsernameInBackground: username password:password block:^(PFUser *user, NSError *error){
        block(user, error);
    }];
}

+ (void)updateUserInfoWithUser: (User *)user WithBlock: (PFBooleanResultBlock)block
{
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        block(succeeded, error);
    }];
}
@end
