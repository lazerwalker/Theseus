//
//  Stop.h
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

@import MapKit;

@class Path;
@class Venue;

#import "TimedEvent.h"

@interface Stop : TimedEvent

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
