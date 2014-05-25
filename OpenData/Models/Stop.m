//
//  Stop.m
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "Stop.h"
#import "CDStop.h"

#import "Path.h"
#import "RawLocation.h"
#import "CDPath.h"
#import "CDRawLocation.h"
#import "Venue.h"

#import <Asterism.h>

@interface Stop ()
@property (nonatomic, strong) CDStop *model;
@end

@implementation Stop
+ (Class)modelClass {
    return CDStop.class;
}

- (void)addPath:(Path *)path {
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

    // TODO: This logic needs to be way more complex, ideally taking into account both GPS accuracy and the radius of nearby Foursquare venues.
    return distance < 100;
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

#pragma mark - Core Data Attributes
- (NSSet *)locations {
    NSSet *locations = self.model.locations;
    return ASTMap(locations, ^id(CDRawLocation *location) {
        return [[RawLocation alloc] initWithModel:location context:self.context];
    });
}

- (void)setLocations:(NSSet *)locations {
    NSSet *coreDataObjects = ASTMap(locations, ^id(RawLocation *location) {
        return location.model;
    });

    self.model.locations = coreDataObjects;
}

- (NSSet *)movementPaths {
    NSSet *paths = self.model.movementPaths;
    return ASTMap(paths, ^id(CDPath *path) {
        return [[Path alloc] initWithModel:path context:self.context];
    });
}

- (Venue *)venue {
    return [[Venue alloc] initWithModel:self.model.venue];
}

- (void)setVenue:(Venue *)venue {
    self.model.venue = venue.model;
}

@end
