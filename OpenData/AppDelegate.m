//
//  AppDelegate.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "AppDelegate.h"
#import "MotionManager.h"
#import "ViewController.h"

@import CoreData;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupAutoMigratingCoreDataStack];

    self.window.rootViewController = [ViewController new];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    MotionManager *manager = [MotionManager new];
    [manager fetchUpdatesWhileInactive];
}

@end
