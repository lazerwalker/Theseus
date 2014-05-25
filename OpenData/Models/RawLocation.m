//
//  RawLocation.m
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "RawLocation.h"
#import "CDRawLocation.h"

@interface RawLocation ()
@property (nonatomic, strong) CDRawLocation *model;
@end

@implementation RawLocation

+ (Class)modelClass {
    return CDRawLocation.class;
}

- (void)setupWithLocation:(CLLocation *)location {
    self.timestamp = location.timestamp;
    self.altitude = location.altitude;
    self.horizontalAccuracy = location.horizontalAccuracy;
    self.verticalAccuracy = location.verticalAccuracy;
    self.speed = location.speed;

    self.coordinate = location.coordinate;
}

- (CLLocationDistance)distanceFromLocation:(RawLocation *)location {
    CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];

    CLLocation *thatLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];

    return [thisLocation distanceFromLocation:thatLocation];
}

#pragma mark - Core Data accessors
- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.model.latitude.doubleValue, self.model.longitude.doubleValue);
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    self.model.latitude = @(coordinate.latitude);
    self.model.longitude = @(coordinate.longitude);
}

- (NSDate *)timestamp {
    return self.model.timestamp;
}

- (void)setTimestamp:(NSDate *)timestamp {
    self.model.timestamp = timestamp;
}

- (CLLocationDistance)altitude {
    return self.model.altitude.doubleValue;
}

- (void)setAltitude:(CLLocationDistance)altitude {
    self.model.altitude = @(altitude);
}

- (CLLocationAccuracy)horizontalAccuracy {
    return self.model.horizontalAccuracy.doubleValue;
}

- (void)setHorizontalAccuracy:(CLLocationAccuracy)horizontalAccuracy {
    self.model.horizontalAccuracy = @(horizontalAccuracy);
}

- (CLLocationAccuracy)verticalAccuracy {
    return self.model.verticalAccuracy.doubleValue;
}

- (void)setVerticalAccuracy:(CLLocationAccuracy)verticalAccuracy {
    self.model.verticalAccuracy = @(verticalAccuracy);
}

- (CLLocationSpeed)speed {
    return self.model.speed.doubleValue;
}

- (void)setSpeed:(CLLocationSpeed)speed {
    self.model.speed = @(speed);
}

@end
