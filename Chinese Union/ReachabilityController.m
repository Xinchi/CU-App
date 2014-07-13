//
//  ReachabilityController.m
//  Chinese Union
//
//  Created by Max Gu on 7/13/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "ReachabilityController.h"
#import "MRPRogress.h"

@implementation ReachabilityController

+(void) registerForViewController:(UIViewController *)uiViewController
{
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability * reachability)
    {

    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MRProgressOverlayView showOverlayAddedTo:uiViewController.view title:@"No internet connection" mode:MRProgressOverlayViewModeCross animated:YES];
//            [self performSelector:@selector(dismissOverlayWithController:) withObject:uiViewController afterDelay:1.0];
//        });
        NSLog(@"No internet!");
    };
    
    [reach startNotifier];
}

+(void) checkConnectionStatusForViewController: (UIViewController *)VC
{
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
//    if(reach.currentReachabilityStatus==NotReachable)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MRProgressOverlayView showOverlayAddedTo:VC.view title:@"No internet connection" mode:MRProgressOverlayViewModeCross animated:YES];
//            [self performSelector:@selector(dismissOverlayWithController:) withObject:VC afterDelay:1.0];
//        });
//    }
        NSLog(@"No internet!");
}

+ (void) dismissOverlayWithController:(UIViewController *)VC
{
    [MRProgressOverlayView dismissAllOverlaysForView:VC.view animated:YES];
}


@end
