//
//  PAPHomeViewController.h
//  Anypic
//
//  Created by Héctor Ramos on 5/3/12.
//

#import "PAPPhotoTimelineViewController.h"
#import "FBCallBack.h"
#import "AppDelegate.h"

@interface PAPHomeViewController : PAPPhotoTimelineViewController <FBCallBackDelegate, RemoteNotificationDelegate>

@property (nonatomic, assign, getter = isFirstLaunch) BOOL firstLaunch;

@end
