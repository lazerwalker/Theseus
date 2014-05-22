//
//  AppDelegate.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "ListViewController.h"

#import "LocationManager.h"
#import "MotionManager.h"
#import "Configuration.h"

#import <DropboxSDK.h>

@interface AppDelegate ()

@property (strong, nonatomic) LocationManager *locationManager;
@property (strong, nonatomic) MotionManager *motionManager;

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupAutoMigratingCoreDataStack];

    [self setupDropbox];

    UINavigationController *listNav = [[UINavigationController alloc] initWithRootViewController:[ListViewController new]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = listNav;
    [self.window makeKeyAndVisible];

    [self startMonitoring];

    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    MotionManager *manager = [MotionManager new];
    [manager fetchUpdatesWhileInactive];
}

#pragma mark - Private
- (void)setupDropbox {
    Configuration *config = [Configuration new];
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:config.dropboxAppKey
                            appSecret:config.dropboxAppSecret
                            root:kDBRootAppFolder];

    DBSession.sharedSession = dbSession;
}

- (void)startMonitoring {
    self.locationManager = [LocationManager new];
    [self.locationManager startMonitoring];

    self.motionManager = [MotionManager new];
    [self.motionManager startMonitoring];
}

@end
