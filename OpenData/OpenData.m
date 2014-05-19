//
//  OpenData.m
//  OpenData
//
//  Created by Michael Walker on 5/19/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "OpenData.h"

static NSUInteger activeNetworkCount = 0;

@implementation OpenData

+ (void)showNetworkActivitySpinner {
    UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
    activeNetworkCount++;
}

+ (void)hideNetworkActivitySpinner {
    if (activeNetworkCount > 0) {
        activeNetworkCount--;
    }

    if (activeNetworkCount <= 0) {
        UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
    }
}

@end
