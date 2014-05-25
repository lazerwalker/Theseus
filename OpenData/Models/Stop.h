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

@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;
@property (nonatomic) NSSet *locations;
@property (nonatomic) NSSet *movementPaths;
@property (nonatomic) NSNumber *venueConfirmed;
@property (nonatomic) Venue *venue;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) CLLocationDistance altitude;
@property (nonatomic, readonly) NSTimeInterval duration;

- (void)setupWithLocations:(NSArray *)locations;
- (BOOL)isSameLocationAs:(Stop *)stop;
- (void)mergeWithStop:(Stop *)stop;
- (void)addPath:(Path *)path;
- (CLLocationDistance)distanceFromCoordinate:(CLLocationCoordinate2D)coordinate;

// MagicalRecord methods to remove
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context;
+ (id) MR_createInContext:(NSManagedObjectContext *)context;
- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context;
- (BOOL) MR_deleteEntity;

@end
