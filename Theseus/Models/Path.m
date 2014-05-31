//
//  Path.m
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

#import "Path.h"
#import "CDPath.h"

#import "Stop.h"
#import "CDStop.h"
#import "RawMotionActivity.h"
#import "RawLocation.h"
#import "CDRawMotionActivity.h"
#import "CDRawLocation.h"

#import <Asterism.h>

@interface Path ()
@property (nonatomic, strong) CDPath *model;
@end

@implementation Path
+ (Class)modelClass {
    return CDPath.class;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dict = [super JSONKeyPathsByPropertyKey];
    return [dict mtl_dictionaryByAddingEntriesFromDictionary:@{@"locations": NSNull.null,
                                                               @"activity": NSNull.null,
                                                               @"stop":NSNull.null}];
}

- (NSString *)typeString {
    NSArray *types = @[@"Unknown",
                       @"Walking",
                       @"Running",
                       @"Biking",
                       @"Transit"];
    return types[self.type];
}

- (MovementType)type {
    if (self.activity.activity == RawMotionActivityTypeWalking) {
        return MovementTypeWalking;
    } else if (self.activity.activity == RawMotionActivityTypeRunning) {
        return MovementTypeRunning;
    } else if (self.activity.activity == RawMotionActivityTypeAutomotive) {
        return MovementTypeTransit;
    } else {
        return MovementTypeUnknown;
    }
}

- (void)addLocations:(NSArray *)locations {
    NSArray *coreDataObjects = ASTMap(locations, ^id(RawLocation *location) {
        return location.model;
    });

    self.model.locations = [self.model.locations setByAddingObjectsFromArray:coreDataObjects];
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

- (RawMotionActivity *)activity {
    return [[RawMotionActivity alloc] initWithCDModel:self.model.activity];
}

- (void)setActivity:(RawMotionActivity *)activity {
    self.model.activity = (CDRawMotionActivity *)activity.model;
}

- (Stop *)stop {
    return [[Stop alloc] initWithCDModel:self.model.stop];
}

- (void)setStop:(Stop *)stop {
    self.model.stop = (CDStop *)stop.model;
}

@end
