//
//  Venue.h
//  Theseus
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Mantle.h>
@import CoreLocation;

@class CDVenue;
@class FoursquareVenue;

@interface Venue : MTLModel<MTLJSONSerializing>

@property (nonatomic) CDVenue *model;
@property (nonatomic) NSString *name;
@property (nonatomic, readonly) NSString *foursquareId;
@property (nonatomic, readonly) NSSet *stops;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

@property (nonatomic, readonly) NSURL *iconURL;

@property (nonatomic, retain) NSString* foursquareIconSuffix;
@property (nonatomic, retain) NSString* foursquareIconPrefix;

- (id)initWithCDModel:(CDVenue *)model;

- (void)destroy;
- (void)setupWithFoursquareVenue:(FoursquareVenue *)venue;

// MagicalRecord methods to remove
+ (id)MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm;

@end
