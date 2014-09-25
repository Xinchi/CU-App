//
//  AppDelegate.h
//  Chinese Union
//
//  Created by Max Gu on 6/3/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol RemoteNotificationDelegate <NSObject>

@required
- (void) didReceiveRemoteNotification;

@end
@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) id<RemoteNotificationDelegate> delegate;
@property (nonatomic, readonly) int networkStatus;

- (BOOL)isParseReachable;

@end
