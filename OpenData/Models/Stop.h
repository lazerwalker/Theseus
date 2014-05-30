//
//  Stop.h
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@import MapKit;

@class Path;
@class Venue;

#import "TimedEvent.h"

@interface Stop : TimedEvent<MKAnnotation>

@property (nonatomic) NSSet *locations;
@property (nonatomic) NSSet *movementPaths;
@property (nonatomic, assign) BOOL venueConfirmed;
@property (nonatomic) Venue *venue;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) CLLocationDegrees latitude;
@property (nonatomic, readonly) CLLocationDegrees longitude;
@property (nonatomic, readonly) CLLocationDistance altitude;

- (void)setupWithLocations:(NSArray *)locations;
- (BOOL)isSameLocationAs:(Stop *)stop;
- (void)mergeWithStop:(Stop *)stop;
- (void)addPath:(Path *)path;
- (CLLocationDistance)distanceFromCoordinate:(CLLocationCoordinate2D)coordinate;

@end
