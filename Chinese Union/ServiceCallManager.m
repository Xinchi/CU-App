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
#import "Constants.h"
#import "Order.h"
#import "CUProducts.h"
#import "CUMainViewController.h"
#import "Order.h"
#import "CUOfficers.h"

@implementation ServiceCallManager

static CUMainViewController *mainViewController;
const NSTimeInterval configRefreshInterval = 12.0 * 60.0 * 60.0;
static NSDate *lastFetchedDate;

+ (void)setMainViewController:(CUMainViewController *) mainVC
{
    mainViewController = mainVC;
}

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

+ (void)getCurrentDateWithBlock: (CUDateResultBlock)block
{
    [PFCloud callFunctionInBackground:CloudFunctionGetCurrentDate withParameters:@{} block:^(id object, NSError *error) {
        block((NSDate *)object, error);
    }];
}

+ (NSDate *)getCurrentDate
{
    NSDate *date = (NSDate *)[PFCloud callFunction:CloudFunctionGetCurrentDate withParameters:@{}];
    return date;
}

+ (User *)getCurrentUser
{
    User *user = [User currentUser];
    MyLog(@"Expensive operation here: [user refresh] in [ServiceCallManager getCurrentUser]");
    [user refresh];
    return user;
}

+(void)getUserWithObjectId:(NSString *)userObjectId WithBlock:(CUUserResultBlock)block
{
    PFQuery *query = [User query];
    [query getObjectInBackgroundWithId:userObjectId block:^(PFObject *user, NSError *error){
        block((User *)user, error);
    }];
}

+ (void)checkIfTheUserIsAMemberWithBlock:(PFBooleanResultBlock)block
{
    [self getCurrentUserWithBlock:^(User *user, NSError *error) {
        block(user.cuMember!=nil, error);
    }];
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
    NSArray *batches = [NSArray arrayWithObjects:BATCH1314, BATCH1415, nil];
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
    else if(type == OFFICER)
    {
        query = [CUOfficers query];
    }
    else if(type == PERSONNEL)
    {
        query = [CUPersonnel query];
        [query orderByAscending:@"order"];
    }
    else {
        [NSException raise:@"Invalid Figure Type" format:@"type of %d is invalid",type];
    }
    if(batch!=nil)
    {
        [query whereKey:BATCH_FIELD equalTo:batch];
    }
    query.limit = 1000;
    [query includeKey:@"associatedPerson"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}

+ (void)getEventsWithSortingOrder: (SortOrder)order WithBlock:(PFArrayResultBlock)block
{
    PFQuery *query = [CUEvents query];
    if(order == ASCENDING)
    {
        [query orderByAscending:CUEVENT_START_DATE];
    } else if (order == DESCENDING) {
        [query orderByDescending:CUEVENT_START_DATE];
    }
    [query includeKey:@"product"];
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

+ (BOOL)VerifyPasswordWithPassword: (NSString*)password
{
    User *user = [self getCurrentUser];
    if([PFUser logInWithUsername:user.username password:password] != nil)
    {
        return YES;
    } else {
        return NO;
    }
}

+ (PFObject *) fecthForObject: (PFObject *)object
{
    [object fetch];
    return object;
}

+ (void)getAllPurchaseHistoryWithSortingOrder: (SortOrder)order WithBlock: (PFArrayResultBlock)block
{
//    PFQuery *customer = [Order query];
//    [customer whereKey:ORDERS_CUSTOMER equalTo:[self getCurrentUser]];
//    PFQuery *charged = [Order query];
//    [charged whereKey:ORDERS_CHARGED equalTo:@YES];
//    PFQuery *query = [PFQuery orQueryWithSubqueries:@[customer, charged]];
    PFQuery *query = [Order query];
    [query whereKey:ORDERS_CUSTOMER equalTo:[self getCurrentUser]];
    [query whereKey:ORDERS_CHARGED equalTo:@YES];
    if(order == ASCENDING)
    {
        [query orderByAscending:CREATION_DATE];
    } else if (order == DESCENDING) {
        [query orderByDescending:CREATION_DATE];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    }];
}

+ (void)logOut{
    MyLog(@"[ServiceCallManager logOut]");
    // clear cache
    [[PAPCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications
    [[PFInstallation currentInstallation] removeObjectForKey:kPAPInstallationUserKey];
    [[PFInstallation currentInstallation] removeObject:[[PFUser currentUser] objectForKey:kPAPUserPrivateChannelKey] forKey:kPAPInstallationChannelsKey];
    [[PFInstallation currentInstallation] saveEventually];
    
    [User logOut];
    
    if(mainViewController != nil && [mainViewController respondsToSelector:@selector(cleanupAfterLoggingOut)]) {
        [mainViewController cleanupAfterLoggingOut];
    }
    
}


+ (void)getMembershipProductWithBlock: (PFObjectResultBlock)block
{
    PFQuery *query = [CUProducts query];
    [query getObjectInBackgroundWithId:CUMemberObjectID block:^(PFObject *object, NSError *error){
        block(object, error);
    }];
}

+ (void)getAppConfigWithBlock: (CUAppConfigResultBlock)block
{
    // Fetches the config at most once every 12 hours per app runtime

    if (lastFetchedDate == nil ||
        [lastFetchedDate timeIntervalSinceNow] * -1.0 > configRefreshInterval) {
        MyLog(@"Fetching new config");
        [PFConfig getConfigInBackgroundWithBlock:^(PFConfig *config, NSError *error) {
            block(config,error);
        }];
        lastFetchedDate = [NSDate date];
    } else {
        MyLog(@"Using cached config");
        block([PFConfig currentConfig],nil);
    }
}


+ (Order *)getOrderWithObjectId: (NSString *)orderId
{
    PFQuery *query = [Order query];
    Order *order = (Order *)[query getObjectWithId:orderId];
    return order;
}

@end
