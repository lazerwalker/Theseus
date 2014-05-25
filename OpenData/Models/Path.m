//
//  Path.m
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "Path.h"
#import "CDPath.h"

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

@end
