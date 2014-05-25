//
//  RawLocation.h
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@import MapKit;

@interface RawLocation : NSObject

@property (nonatomic) NSDate *timestamp;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) CLLocationDistance altitude;
@property (nonatomic) CLLocationSpeed speed;
@property (nonatomic) CLLocationAccuracy horizontalAccuracy;
@property (nonatomic) CLLocationAccuracy verticalAccuracy;

- (void)setupWithLocation:(CLLocation *)location;
- (CLLocationDistance)distanceFromLocation:(RawLocation *)location;

// MagicalRecord
+ (id) MR_createInContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

@end
