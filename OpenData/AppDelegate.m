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
#import "DaysAgoDataSource.h"
#import "LocationManager.h"
#import "MotionManager.h"
#import "Configuration.h"
#import "DataProcessor.h"

#import <DropboxSDK/DropboxSDK.h>

@interface AppDelegate ()

@property (strong, nonatomic) LocationManager *locationManager;
@property (strong, nonatomic) MotionManager *motionManager;
@property (strong, nonatomic) DaysAgoDataSource *daysAgoDataSource;

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupAutoMigratingCoreDataStack];

    [self setupAppearance];
    [self setupDropbox];

    UIPageViewController *dayPages = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                     navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                   options:nil];
    dayPages.dataSource = self.daysAgoDataSource = [DaysAgoDataSource new];
    UIViewController *initialController = [self.daysAgoDataSource controllerForDaysAgo:0];
    [dayPages setViewControllers:@[initialController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = dayPages;
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
- (void)setupAppearance {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"STHeitiTC-Medium" size:18.0]}];
}

- (void)startMonitoring {
    self.locationManager = [LocationManager new];
    [self.locationManager startMonitoring];

    self.motionManager = [MotionManager new];
    [self.motionManager startMonitoring];
}

#pragma mark - Dropbox
- (void)setupDropbox {
    Configuration *config = [Configuration new];
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:config.dropboxAppKey
                            appSecret:config.dropboxAppSecret
                            root:kDBRootAppFolder];

    DBSession.sharedSession = dbSession;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            [[[UIAlertView alloc] initWithTitle:@"Linked With Dropbox" message:@"Successfully linked. Try your export again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"An Error Occurred" message:@"Could not link with Dropbox. Try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

@end
