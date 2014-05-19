//
//  Venue.h
//  OpenData
//
//  Created by Michael Walker on 5/19/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@import CoreLocation;

@class FoursquareVenue;

@interface Venue : NSManagedObject

@property (nonatomic, retain) NSString* foursquareId;
@property (nonatomic, retain) NSNumber* latitude;
@property (nonatomic, retain) NSNumber* longitude;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSSet *stops;

@property (nonatomic) CLLocationCoordinate2D coordinate;

- (void)setupWithFoursquareVenue:(FoursquareVenue *)venue;

@end
