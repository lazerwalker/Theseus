//
//  Venue.m
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "Venue.h"
#import "CDVenue.h"
#import "FoursquareVenue.h"

@interface Venue ()
@property (nonatomic, strong) CDVenue *model;
@end

@implementation Venue

+ (Class)modelClass {
    return CDVenue.class;
}

- (void)setupWithFoursquareVenue:(FoursquareVenue *)venue {
    self.model.name = venue.name;
    self.model.foursquareId = venue.foursquareId;
    self.model.latitude = venue.latitude;
    self.model.longitude = venue.longitude;

    self.foursquareIconPrefix = venue.iconPrefix.firstObject;
    self.foursquareIconSuffix = venue.iconSuffix.firstObject;
}

- (CLLocationCoordinate2D) coordinate {
    return CLLocationCoordinate2DMake(self.model.latitude.doubleValue, self.model.longitude.doubleValue);
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    self.model.latitude = @(coordinate.latitude);
    self.model.longitude = @(coordinate.longitude);
}

- (NSURL *)iconURL {
    if (!(self.foursquareIconPrefix && self.foursquareIconSuffix)) return nil;
    NSString *url = [NSString stringWithFormat:@"%@bg_64%@", self.foursquareIconPrefix, self.foursquareIconSuffix];
    return [NSURL URLWithString:url];
}

#pragma mark - Core Data accessors
- (NSString *)foursquareId {
    return self.model.foursquareId;
}

- (NSString *)name {
    return self.model.name;
}

- (void)setName:(NSString *)name {
    self.model.name = name;
}

- (NSSet *)stops {
    return self.model.stops;
}

#pragma mark - Magical Record
+ (id)MR_createEntity {
    return [self.modelClass MR_createEntity];
}

- (BOOL)MR_deleteEntity {
    return [self.model MR_deleteEntity];
}

+ (id) MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue {
    return [self.modelClass MR_findFirstByAttribute:attribute withValue:searchValue];
}

+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchTerm {
    return [self.modelClass MR_findAllWithPredicate:searchTerm];
}

@end
