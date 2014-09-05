//
//  ParseServiceManager.m
//  Chinese Union
//
//  Created by Max Gu on 8/10/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "ServiceCallManager.h"
#import "User.h"
#import "CUBasketballPlayer.h"
#import "CUSoccerPlayer.h"
#import "CUPersonnel.h"
#import "CUEvents.h"

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

+ (User *)getCurrentUser
{
    User *user = [User currentUser];
    [user refresh];
    return user;
}
+ (void)getCurrentUserWithBlock:(CUUserResultBlock)block
{
    User *user = [User currentUser];
    [user refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        block((User *)object, error);
    }];
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

+ (BOOL)checkIfUsernameExisted: (NSString *)username
{
    PFQuery *query = [User query];
    [query whereKey:USERNAME_FIELD equalTo:username];
    NSArray *users = [query findObjects];
    if([users count]>0)
        return YES;
    return NO;
}

+ (BOOL)checkIfEmailExisted: (NSString *)email
{
    PFQuery *query = [User query];
    [query whereKey:EMAIL_FIELD equalTo:email];
    NSArray *users = [query findObjects];
    if([users count]>0)
        return YES;
    return NO;
}

+ (NSArray *)getAllTheBatches
{
    NSArray *batches = [NSArray arrayWithObjects:BATCH1011,BATCH1112,BATCH1213,BATCH1314,nil];
    return batches;
}


+ (void)getObjectsWithType:(ObjectType)type WithBatch:(NSString *)batch WithBlock:(PFArrayResultBlock)block
{
    PFQuery *query;
    if(type == BASKETBALL)
    {
        query = [CUBasketballPlayer query];
    }
    else if(type == SOCCER)
    {
        query = [CUSoccerPlayer query];
    }
    else if(type == PERSONNEL)
    {
        query = [CUPersonnel query];
    }
    else if(type == EVENT)
    {
        query = [CUEvents query];
    }
    else {
        [NSException raise:@"Invalid Figure Type" format:@"type of %d is invalid",type];
    }
    if(batch!=nil)
    {
        [query whereKey:BATCH_FIELD equalTo:batch];
    }
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}

+ (void)logOutAndDeleteCurrentUserAccountWithBlock: (PFBooleanResultBlock)block
{
    MyLog(@"---logOutAndDeleteCurrentUserAccount---");
    User *accountToBeDeleted = [User currentUser];
    [accountToBeDeleted refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error)
        {
            [accountToBeDeleted deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(!error) {
                    [User logOut];
                    block(succeeded,error);
                }else {
                    block(NO,error);
                }
            }];
        }else {
            block(NO,error);
        }
    }];
}


@end
