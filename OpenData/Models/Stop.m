//
//  Location.m
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "Stop.h"

@implementation Stop

@dynamic startTime, endTime, locations, movementPaths, venue, venueConfirmed;

- (NSTimeInterval)duration {
    return [self.endTime timeIntervalSinceDate:self.startTime];
}

- (void)addMovementPath:(MovementPath *)path {
    NSSet *paths = self.movementPaths ?: [NSSet new];
    paths = [paths setByAddingObject:path];
    self.movementPaths = paths;
}

- (void)mergeWithStop:(Stop *)stop {
    NSArray *locations = [[self.locations setByAddingObjectsFromSet:stop.locations] allObjects];
    [self setupWithLocations:locations];
}

- (BOOL)isSameLocationAs:(Stop *)stop {
    CLLocationDistance distance = [self distanceFromCoordinate:stop.coordinate];
    return distance < 50;
}

- (CLLocationDistance)distanceFromCoordinate:(CLLocationCoordinate2D)coordinate {
    CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];

    CLLocation *thatLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];

    return [thisLocation distanceFromLocation:thatLocation];
}

#pragma mark - Accessors
- (CLLocationCoordinate2D)coordinate {
    CLLocationDegrees latitude = [[self.locations valueForKeyPath:@"@avg.latitude"] doubleValue];
    CLLocationDegrees longitude = [[self.locations valueForKeyPath:@"@avg.longitude"] doubleValue];

    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (CLLocationDistance)altitude {
    return [[self.locations valueForKeyPath:@"@avg.altitude"] doubleValue];
}


#pragma mark - Private
- (void)setupWithLocations:(NSArray *)locations {
    self.locations = [NSSet setWithArray:locations];

    self.startTime = [locations valueForKeyPath:@"@min.timestamp"];
    self.endTime = [locations valueForKeyPath:@"@max.timestamp"];
}

@end
