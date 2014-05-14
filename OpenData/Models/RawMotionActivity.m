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

- (void)setupWithMotionActivity:(CMMotionActivity *)activity {
    self.timestamp = activity.startDate;
    self.confidence = @(activity.confidence);

    if (activity.walking) {
        self.activity = @(RawMotionActivityTypeWalking);
    } else if (activity.running) {
        self.activity = @(RawMotionActivityTypeRunning);
    } else if (activity.automotive) {
        self.activity = @(RawMotionActivityTypeAutomotive);
    } else if (activity.stationary) {
        self.activity = @(RawMotionActivityTypeStationary);
    } else {
        self.activity = @(RawMotionActivityTypeUnknown);
    }
}

- (RawMotionActivityType)activityType {
    return (RawMotionActivityType)self.activity.integerValue;
}

@end
