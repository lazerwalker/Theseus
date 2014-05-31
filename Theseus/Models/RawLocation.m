//
//  RawLocation.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/25/14.
//  Copyright (c) 2014 Mike Lazer-Walker
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>
#import "RawLocation.h"
#import "CDRawLocation.h"

@interface RawLocation ()
@property (nonatomic, strong) CDRawLocation *model;
@end

@implementation RawLocation

+ (Class)modelClass {
    return CDRawLocation.class;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dict = [super JSONKeyPathsByPropertyKey];
    return [dict mtl_dictionaryByAddingEntriesFromDictionary:@{@"coordinate": NSNull.null}];
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
- (CLLocationDegrees)latitude {
    return self.model.latitude.doubleValue;
}

- (void)setLatitude:(CLLocationDegrees)latitude {
    self.model.latitude = @(latitude);
}

- (CLLocationDegrees)longitude {
    return self.model.longitude.doubleValue;
}

- (void)setLongitude:(CLLocationDegrees)longitude {
    self.model.longitude = @(longitude);
}

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
