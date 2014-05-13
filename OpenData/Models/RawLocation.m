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

+ (instancetype)createWithLocation:(CLLocation *)location {
    RawLocation *entity = [RawLocation MR_createEntity];

    entity.timestamp = location.timestamp;
    entity.altitude = @(location.altitude);
    entity.horizontalAccuracy = @(location.horizontalAccuracy);
    entity.verticalAccuracy = @(location.verticalAccuracy);
    entity.speed = @(location.speed);

    entity.latitude = @(location.coordinate.latitude);
    entity.longitude = @(location.coordinate.longitude);

    return entity;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}

@end
