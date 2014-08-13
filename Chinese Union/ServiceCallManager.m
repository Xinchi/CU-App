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

+ (BOOL)checkIfUsernameExisted: (NSString *)username
{
    PFQuery *query = [User query];
    [query whereKey:@"username" equalTo:username];
    NSArray *users = [query findObjects];
    if([users count]>0)
        return YES;
    return NO;
}

+ (BOOL)checkIfEmailExisted: (NSString *)email
{
    PFQuery *query = [User query];
    [query whereKey:@"email" equalTo:email];
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


+ (void)getAllFigureWithType:(FigureType)type WithBlock:(PFArrayResultBlock)block
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
    }else {
        [NSException raise:@"Invalid Figure Type" format:@"type of %@ is invalid",type];
    }
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
    
}

@end
