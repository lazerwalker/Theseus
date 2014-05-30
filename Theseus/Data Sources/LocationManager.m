//
//  LocationManager.m
//  Theseus
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "LocationManager.h"
#import "RawLocation.h"

@import CoreLocation;

@interface LocationManager ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *manager;
@end

@implementation LocationManager

- (id)init {
    self = [super init];
    if (!self) return nil;

    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.pausesLocationUpdatesAutomatically = NO;
    self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    return self;
}

- (void)startMonitoring {
    if (![CLLocationManager locationServicesEnabled]) return;

    [self.manager startUpdatingLocation];
}

- (void)stopMonitoring {
    [self.manager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (CLLocation *location in locations) {
            RawLocation *rawLocation = [[RawLocation alloc] initWithContext:localContext];
            [rawLocation setupWithLocation:location];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"LOCATIONERROR ================> %@", error);
}

@end
