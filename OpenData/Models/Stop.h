//
//  Location.h
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Mantle.h>
@import MapKit;

@class MovementPath;
@class Venue;

@interface Stop : NSManagedObject<MKAnnotation>

@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;
@property (nonatomic) NSSet *locations;
@property (nonatomic) NSSet *movementPaths;
@property (nonatomic) Venue *venue;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) CLLocationDistance altitude;
@property (nonatomic, readonly) NSTimeInterval duration;

- (void)setupWithLocations:(NSArray *)locations;
- (BOOL)isSameLocationAs:(Stop *)stop;
- (void)mergeWithStop:(Stop *)stop;
- (void)addMovementPath:(MovementPath *)path;
@end
