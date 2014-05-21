//
//  Location.m
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "Stop.h"
#import "MovementPath.h"

@implementation Stop

@dynamic startTime, endTime, locations, movementPaths, venue, venueConfirmed;

- (void)addMovementPath:(MovementPath *)path {
    NSSet *paths = self.movementPaths ?: [NSSet new];
    paths = [paths setByAddingObject:path];
    path.stop = self;
    self.movementPaths = paths;
}

- (void)mergeWithStop:(Stop *)stop {
    NSArray *locations = [[self.locations setByAddingObjectsFromSet:stop.locations] allObjects];
    [self setupWithLocations:locations];
}

- (BOOL)isSameLocationAs:(Stop *)stop {
    CLLocationDistance distance = [self distanceFromCoordinate:stop.coordinate];

    // TODO: The magic number 310 is roughly 1 Manhattan city block.
    // Eventually, this logic needs to be way more complex, ideally taking into account both GPS accuracy and the radius of nearby Foursquare venues. 
    return distance < 310;
}

- (CLLocationDistance)distanceFromCoordinate:(CLLocationCoordinate2D)coordinate {
    CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];

    CLLocation *thatLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];

    return [thisLocation distanceFromLocation:thatLocation];
}

- (void)setupWithLocations:(NSArray *)locations {
    self.locations = [NSSet setWithArray:locations];

    self.startTime = [locations valueForKeyPath:@"@min.timestamp"];
    self.endTime = [locations valueForKeyPath:@"@max.timestamp"];
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

- (NSTimeInterval)duration {
    return [self.endTime timeIntervalSinceDate:self.startTime];
}

@end
