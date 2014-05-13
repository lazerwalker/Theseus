//
//  RawMotionActivity.m
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "RawMotionActivity.h"

@implementation RawMotionActivity

@dynamic timestamp;
@dynamic activity;
@dynamic confidence;

+ (instancetype)createWithMotionActivity:(CMMotionActivity *)activity {
    RawMotionActivity *entity = [RawMotionActivity MR_createEntity];
    entity.timestamp = activity.startDate;
    entity.confidence = @(activity.confidence);

    if (activity.walking) {
        entity.activity = @(RawMotionActivityTypeWalking);
    } else if (activity.running) {
        entity.activity = @(RawMotionActivityTypeRunning);
    } else if (activity.automotive) {
        entity.activity = @(RawMotionActivityTypeAutomotive);
    } else if (activity.stationary) {
        entity.activity = @(RawMotionActivityTypeStationary);
    } else {
        entity.activity = @(RawMotionActivityTypeUnknown);
    }

    return entity;
}

- (RawMotionActivityType)activityType {
    return (RawMotionActivityType)self.activity.integerValue;
}

@end
