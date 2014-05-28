//
//  Stop.m
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

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

- (void)addPath:(Path *)path {
    NSSet *paths = self.model.movementPaths ?: [NSSet new];
    paths = [paths setByAddingObject:path.model];
    self.model.movementPaths = paths;
}

- (void)mergeWithStop:(Stop *)stop {
    NSArray *locations = [[self.locations setByAddingObjectsFromSet:stop.locations] allObjects];
    [self setupWithLocations:locations];
}

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

- (void)setupWithLocations:(NSArray *)locations {
    self.locations = [NSSet setWithArray:locations];

    self.startTime = [locations valueForKeyPath:@"@min.timestamp"];
    self.endTime = [locations valueForKeyPath:@"@max.timestamp"];
}

#pragma mark - Accessors
- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (CLLocationDistance)altitude {
    return [[self.locations valueForKeyPath:@"@avg.altitude"] doubleValue];
}

- (CLLocationDegrees)latitude {
    return [[self.locations valueForKeyPath:@"@avg.latitude"] doubleValue];
}

- (CLLocationDegrees)longitude {
    return [[self.locations valueForKeyPath:@"@avg.longitude"] doubleValue];
}

#pragma mark - Core Data Attributes
- (NSSet *)locations {
    NSSet *locations = self.model.locations;
    return ASTMap(locations, ^id(CDRawLocation *location) {
        return [[RawLocation alloc] initWithCDModel:location context:self.context];
    });
}

- (void)setLocations:(NSSet *)locations {
    NSSet *coreDataObjects = ASTMap(locations, ^id(RawLocation *location) {
        return location.model;
    });

    self.model.locations = coreDataObjects;
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
