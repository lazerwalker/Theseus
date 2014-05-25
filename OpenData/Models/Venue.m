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

#import <Asterism.h>

@implementation Venue

+ (Class)modelClass {
    return CDVenue.class;
}

- (id)initWithModel:(CDVenue *)model {
    if (!model) return nil;
    if (!(self = [super init])) return nil;
    self.model = model;
    return self;
}

- (id)init {
    if (!(self = [super init])) return nil;
    self.model = [CDVenue MR_createEntity];
    return self;
}

- (void)destroy {
    [self.model MR_deleteEntity];
}

- (void)setupWithFoursquareVenue:(FoursquareVenue *)venue {
    self.name = venue.name;
    self.foursquareId = venue.foursquareId;
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

- (void)setFoursquareId:(NSString *)foursquareId {
    self.model.foursquareId = foursquareId;
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
+ (id)MR_findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue {
    CDVenue *venue = [self.modelClass MR_findFirstByAttribute:attribute withValue:searchValue];
    return [[self alloc] initWithModel:venue];
}

+ (NSArray *)MR_findAllWithPredicate:(NSPredicate *)searchTerm {
    NSArray *array = [self.modelClass MR_findAllWithPredicate:searchTerm];
    return ASTMap(array, ^id(CDVenue *venue) {
        return [[self alloc] initWithModel:venue];
    });
}

@end
