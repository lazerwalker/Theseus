//
//  Stop.m
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

#import "Stop.h"
#import "CDStop.h"

#import "Path.h"
#import "RawLocation.h"
#import "CDPath.h"
#import "CDRawLocation.h"
#import "Venue.h"

#import <Asterism.h>

@interface Stop ()
@property (nonatomic, strong) CDStop *model;

// These appear to need to be readwrite for Mantle's sake
@property (nonatomic, readwrite) CLLocationDegrees latitude;
@property (nonatomic, readwrite) CLLocationDegrees longitude;
@property (nonatomic, readwrite) CLLocationDistance altitude;

@end

@implementation Stop

#pragma mark - Mantle
+ (Class)modelClass {
    return CDStop.class;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dict = [super JSONKeyPathsByPropertyKey];
    return [dict mtl_dictionaryByAddingEntriesFromDictionary:@{@"locations": NSNull.null,
                                                               @"movementPaths":NSNull.null,
                                                               @"latitude": @"latitude",
                                                               @"longitude": @"longitude",
                                                               @"altitude": @"altitude"}];
}

+ (NSValueTransformer *)venueJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:Venue.class];
}

#pragma mark - Equality and comparisons

- (BOOL)isSameLocationAs:(Stop *)stop {
    CLLocationDistance distance = [self distanceFromCoordinate:stop.coordinate];

    // TODO: This logic needs to be way more complex, ideally taking into account both GPS accuracy and the radius of nearby Foursquare venues.
    return distance < 100;
}

- (CLLocationDistance)distanceFromCoordinate:(CLLocationCoordinate2D)coordinate {
    CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];

    CLLocation *thatLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];

    return [thisLocation distanceFromLocation:thatLocation];
}

#pragma mark - Equality
- (BOOL)isEqual:(Stop *)object {
    if (![object isKindOfClass:Stop.class]) { return NO; }
    return [self.startTime isEqualToDate:object.startTime] &&
        [self.endTime isEqualToDate:object.endTime];
}

- (NSUInteger)hash {
    return self.startTime.hash ^ self.endTime.hash;
}

#pragma mark - Setup
- (void)setupWithVisit:(CLVisit *)visit {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertAction = nil;
    notification.alertBody = [NSString stringWithFormat:@"Setting up with visit: %@, %@, %f, %f", visit.arrivalDate, visit.departureDate, visit.coordinate.latitude, visit.coordinate.longitude];
    [UIApplication.sharedApplication presentLocalNotificationNow:notification];

    self.startTime = visit.arrivalDate;
    self.endTime = visit.departureDate;
    self.coordinate = visit.coordinate;
}

#pragma mark - Core Data Attributes
- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    self.model.latitude = @(coordinate.latitude);
    self.model.longitude = @(coordinate.longitude);
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.model.latitude.floatValue, self.model.longitude.floatValue);
}

- (void)setHorizontalAccuracy:(CLLocationAccuracy)horizontalAccuracy {
    self.model.horizontalAccuracy = @(horizontalAccuracy);
}

- (CLLocationAccuracy)horizontalAccuracy {
    return self.model.horizontalAccuracy.floatValue;
}

- (Venue *)venue {
    return [[Venue alloc] initWithCDModel:self.model.venue];
}

- (void)setVenue:(Venue *)venue {
    self.model.venue = venue.model;
}

- (BOOL)venueConfirmed {
    return self.model.venueConfirmed.boolValue;
}

@end
