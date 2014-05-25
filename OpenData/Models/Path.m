//
//  Path.m
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "Path.h"
#import "_MovementPath.h"
#import "RawMotionActivity.h"

@interface Path ()
@property (nonatomic, strong) _MovementPath *model;
@end

@implementation Path
+ (Class)modelClass {
    return _MovementPath.class;
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
    self.locations = [self.locations setByAddingObjectsFromArray:locations];
}

#pragma mark - Core Data Attributes
- (NSSet *)locations {
    return self.model.locations;
}

- (_RawMotionActivity *)activity {
    return self.model.activity;
}

- (void)setActivity:(_RawMotionActivity *)activity {
    self.model.activity = activity;
}

@end
