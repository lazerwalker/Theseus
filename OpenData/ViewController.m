//
//  ViewController.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "ViewController.h"
#import "LocationManager.h"

@interface ViewController ()
@property (strong, nonatomic) LocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationManager = [LocationManager new];
    [self.locationManager startMonitoring];
}


@end
