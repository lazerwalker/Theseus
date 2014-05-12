//
//  ViewController.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "ViewController.h"
#import "LocationManager.h"
#import "MotionManager.h"
#import "LocationList.h"

@interface ViewController ()
@property (strong, nonatomic) LocationManager *locationManager;
@property (strong, nonatomic) MotionManager *motionManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationManager = [LocationManager new];
    [self.locationManager startMonitoring];

    self.motionManager = [MotionManager new];
    [self.motionManager startMonitoring];

    LocationList *list = [LocationList loadFromDisk];
    NSLog(@"================> %@", list.activities);
    NSLog(@"================> %@", list.locations);
}


@end
