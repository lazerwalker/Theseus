//
//  Venue.h
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@import CoreLocation;

@class CDVenue;
@class FoursquareVenue;

@interface Venue : NSObject

@property (nonatomic) CDVenue *model;
@property (nonatomic) NSString *name;
@property (nonatomic, readonly) NSString *foursquareId;
@property (nonatomic, readonly) NSSet *stops;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSURL *iconURL;

@property (nonatomic, retain) NSString* foursquareIconSuffix;
@property (nonatomic, retain) NSString* foursquareIconPrefix;

- (id)initWithModel:(CDVenue *)model;

- (void)destroy;
- (void)setupWithFoursquareVenue:(FoursquareVenue *)venue;

// MagicalRecord methods to remove
+ (id)MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm;

@end
