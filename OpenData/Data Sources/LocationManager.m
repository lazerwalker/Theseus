//
//  LocationManager.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "LocationManager.h"
#import "LocationList.h"

@import CoreLocation;

@interface LocationManager ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *manager;
@end

@implementation LocationManager

- (void)startMonitoring {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
    });

    if (![CLLocationManager locationServicesEnabled]) return;

    [self.manager startUpdatingLocation];
}

- (void)stopMonitoring {
    [self.manager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LocationList *list = [LocationList loadFromDisk];
        [list addLocations:locations];
    });
}
@end
