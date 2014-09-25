//
//  PAPAccountViewController.h
//  Anypic
//
//  Created by Héctor Ramos on 5/3/12.
//

#import "PAPPhotoTimelineViewController.h"
@class User;
@interface PAPAccountViewController : PAPPhotoTimelineViewController

@property (nonatomic, strong) User *user;

@end
