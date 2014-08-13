//
//  ParseServiceManager.h
//  Chinese Union
//
//  Created by Max Gu on 8/10/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CompletionBlock)(id, NSError*);

@class User;
@interface ServiceCallManager : NSObject

+ (ServiceCallManager *)manager;

+ (void)signUpInBackgroundWithUser: (User *)user WithBlock:(PFBooleanResultBlock)block;

+ (void)callFunctionInBackground:(NSString *)function withParameters:(NSDictionary *)parameters block:(PFIdResultBlock)block;

+ (void)logInWithUsernameInBackground:(NSString *)username
                             password:(NSString *)password
                                block:(PFUserResultBlock)block;

+ (void)updateUserInfoWithUser: (User *)user WithBlock: (PFBooleanResultBlock)block;

+ (BOOL)checkIfUsernameExisted: (NSString *)username;

+ (BOOL)checkIfEmailExisted: (NSString *)email;

/**
 * This function returns an NSArray pointer.  Cast the object to desired type to get all the relaven
 *fields. 
 */
+ (void)getAllFigureWithType:(FigureType)type WithBlock:(PFArrayResultBlock)block;



+ (NSArray *)getAllTheBatches;

@end
