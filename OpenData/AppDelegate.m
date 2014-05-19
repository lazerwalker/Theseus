//
//  AppDelegate.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "AppDelegate.h"
#import "MotionManager.h"
#import "MapViewController.h"
#import "ListViewController.h"

#import "LocationManager.h"
#import "MotionManager.h"

@interface AppDelegate ()

@property (strong, nonatomic) LocationManager *locationManager;
@property (strong, nonatomic) MotionManager *motionManager;

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupAutoMigratingCoreDataStack];

    UITabBarController *tabController = [UITabBarController new];

    UINavigationController *mapNav = [[UINavigationController alloc] initWithRootViewController:[MapViewController new]];

    UINavigationController *listNav = [[UINavigationController alloc] initWithRootViewController:[ListViewController new]];

    tabController.viewControllers = @[listNav, mapNav];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabController;
    [self.window makeKeyAndVisible];

    [self startMonitoring];

    return YES;
}

- (void)startMonitoring {
    self.locationManager = [LocationManager new];
    [self.locationManager startMonitoring];

    self.motionManager = [MotionManager new];
    [self.motionManager startMonitoring];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    MotionManager *manager = [MotionManager new];
    [manager fetchUpdatesWhileInactive];
}

@end
