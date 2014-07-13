//
//  ReachabilityController.h
//  Chinese Union
//
//  Created by Max Gu on 7/13/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityController : NSObject

+(void) registerForViewController:(UIViewController *)uiViewController;

+(void) checkConnectionStatusForViewController: (UIViewController *)VC;
@end
