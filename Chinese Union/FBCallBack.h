//
//  FBCallBack.h
//  Chinese Union
//
//  Created by Max Gu on 9/25/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FBCallBackDelegate <NSObject>

@required
- (void)setHud: (NSString*)string;
- (void)setAutoFollowTimer;
- (void)setFirstLaunchField: (BOOL)value;
- (void)handleFollowingFriends;

@end

@interface FBCallBack : NSObject

- (void)FBrequestdidLoad:(id)result;
- (void)FBrequestDidFailWithError:(NSError *)error;

@property (nonatomic, assign) id<FBCallBackDelegate> delegate;

@end
