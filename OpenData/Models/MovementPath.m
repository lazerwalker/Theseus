//
//  MovementPath.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "MovementPath.h"
#import "RawMotionActivity.h"

@implementation MovementPath

@dynamic startTime, endTime, locations, activity;

- (NSTimeInterval)duration {
    return [self.endTime timeIntervalSinceDate:self.startTime];
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
    if (self.activity.activityType == RawMotionActivityTypeWalking) {
        return MovementTypeWalking;
    } else if (self.activity.activityType == RawMotionActivityTypeRunning) {
        return MovementTypeRunning;
    } else if (self.activity.activityType == RawMotionActivityTypeAutomotive) {
        return MovementTypeTransit;
    } else {
        return MovementTypeUnknown;
    }
}

@end
