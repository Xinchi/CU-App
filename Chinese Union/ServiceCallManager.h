//
//  ParseServiceManager.h
//  Chinese Union
//
//  Created by Max Gu on 8/10/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
typedef void (^CompletionBlock)(id, NSError*);

@class User;
@interface ServiceCallManager : NSObject

+ (ServiceCallManager *)manager;

+ (void)getCurrentDateWithBlock: (CUDateResultBlock)block;

+ (User *)getCurrentUser;

+ (void)checkIfTheUserIsAMemberWithBlock:(PFBooleanResultBlock)block;

+ (void)getCurrentUserWithBlock:(CUUserResultBlock)block;

+(void)getUserWithObjectId:(NSString *)userObjectId WithBlock:(CUUserResultBlock)block;

+ (void)signUpInBackgroundWithUser: (User *)user WithBlock:(PFBooleanResultBlock)block;

+ (void)callFunctionInBackground:(NSString *)function withParameters:(NSDictionary *)parameters block:(PFIdResultBlock)block;

+ (void)logInWithUsernameInBackground:(NSString *)username
                             password:(NSString *)password
                                block:(PFUserResultBlock)block;

+ (void)updateUserInfoWithUser: (User *)user WithBlock: (PFBooleanResultBlock)block;

+ (BOOL)checkIfUsernameExisted: (NSString *)username;

+ (BOOL)checkIfEmailExisted: (NSString *)email;

+ (BOOL)VerifyPasswordWithPassword: (NSString*)password;
/**
 * This function returns an NSArray pointer.  Cast the object to desired type to get all the relavent
 * fields.   Put batch as nil if no batch query is needed.
 */
+ (void)getObjectsWithType:(ObjectType)type WithBatch:(NSString *)batch WithBlock:(PFArrayResultBlock)block;

+ (void)getEventsWithSortingOrder: (SortOrder)order WithBlock:(PFArrayResultBlock)block;

+ (NSArray *)getAllTheBatches;


+ (void)logOut;
/**
 * Highly dangerous method, use with extra caution
 */
+ (void)logOutAndDeleteCurrentUserAccountWithBlock: (PFBooleanResultBlock)block;

+ (PFObject *) fecthForObject: (PFObject *)object;

+ (void)getAllPurchaseHistoryWithSortingOrder: (SortOrder)order WithBlock: (PFArrayResultBlock)block;


@end
