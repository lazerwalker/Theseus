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
    self.locations = [self.locations setByAddingObjectsFromArray:locations];
}

#pragma mark - Core Data Attributes
- (NSSet *)locations {
    return self.model.locations;
}

- (CDRawMotionActivity *)activity {
    return self.model.activity;
}

- (void)setActivity:(CDRawMotionActivity *)activity {
    self.model.activity = activity;
}

@end
