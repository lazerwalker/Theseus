//
//  Venue.h
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/25/14.
//  Copyright (c) 2014 Mike Lazer-Walker
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>

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
