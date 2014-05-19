//
//  Venue.h
//  OpenData
//
//  Created by Michael Walker on 5/19/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@class FoursquareVenue;

@interface Venue : NSManagedObject

@property (nonatomic, retain) NSString * foursquareId;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;

- (void)setupWithFoursquareVenue:(FoursquareVenue *)venue;

@end
