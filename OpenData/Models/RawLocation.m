//
//  RawLocation.m
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "RawLocation.h"

@implementation RawLocation

@dynamic timestamp, altitude, horizontalAccuracy, verticalAccuracy, latitude, longitude, speed;

- (void)setupWithLocation:(CLLocation *)location {
    self.timestamp = location.timestamp;
    self.altitude = @(location.altitude);
    self.horizontalAccuracy = @(location.horizontalAccuracy);
    self.verticalAccuracy = @(location.verticalAccuracy);
    self.speed = @(location.speed);

    self.latitude = @(location.coordinate.latitude);
    self.longitude = @(location.coordinate.longitude);
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}

@end
