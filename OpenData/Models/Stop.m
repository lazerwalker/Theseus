//
//  Location.m
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "Stop.h"

@implementation Stop

- (id)initWithLocations:(NSArray *)locations {
    self = [super init];
    if (!self) return nil;

    [self setupWithLocations:locations];
    return self;
}

- (NSTimeInterval)duration {
    return [self.endTime timeIntervalSinceDate:self.startTime];
}

- (void)addMovementPath:(MovementPath *)path {
    self.movementPaths = self.movementPaths ?: [NSMutableArray new];
    [self.movementPaths addObject:path];
}

- (void)mergeWithStop:(Stop *)stop {
    NSArray *locations = [self.locations arrayByAddingObjectsFromArray:stop.locations];
    [self setupWithLocations:locations];
}

- (BOOL)isSameLocationAs:(Stop *)stop {
    CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];

    CLLocation *thatLocation = [[CLLocation alloc] initWithLatitude:stop.coordinate.latitude longitude:stop.coordinate.longitude];

    CLLocationDistance distance = [thisLocation distanceFromLocation:thatLocation];
    return distance < 50;
}

#pragma mark - Private
- (void)setupWithLocations:(NSArray *)locations {
    self.locations = locations;

    self.startTime = [locations valueForKeyPath:@"@min.timestamp"];
    self.endTime = [locations valueForKeyPath:@"@max.timestamp"];

    self.altitude = [[locations valueForKeyPath:@"@avg.altitude"] doubleValue];
    self.horizontalAccuracy = [[locations valueForKeyPath:@"@avg.horizontalAccuracy"] doubleValue];
    self.verticalAccuracy = [[locations valueForKeyPath:@"@avg.verticalAccuracy"] doubleValue];

    CLLocationDegrees latitude = [[locations valueForKeyPath:@"@avg.latitude"] doubleValue];
    CLLocationDegrees longitude = [[locations valueForKeyPath:@"@avg.longitude"] doubleValue];
    self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
}

@end
