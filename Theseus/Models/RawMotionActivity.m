//
//  RawMotionActivity.m
//  Theseus
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "RawMotionActivity.h"
#import "CDRawMotionActivity.h"

@interface RawMotionActivity ()
@property (nonatomic) CDRawMotionActivity *model;
@end

@implementation RawMotionActivity

+ (Class)modelClass {
    return CDRawMotionActivity.class;
}

+ (NSDate *)mostRecentTimestamp {
    RawMotionActivity *activity = [self.modelClass MR_findFirstOrderedByAttribute:@"timestamp" ascending:NO];
    return activity.timestamp ?: [NSDate distantPast];
}

- (void)setupWithMotionActivity:(CMMotionActivity *)activity {
    self.timestamp = activity.startDate;
    self.confidence = activity.confidence;

    if (activity.walking) {
        self.activity = RawMotionActivityTypeWalking;
    } else if (activity.running) {
        self.activity = RawMotionActivityTypeRunning;
    } else if (activity.automotive) {
        self.activity = RawMotionActivityTypeAutomotive;
    } else if (activity.stationary) {
        self.activity = RawMotionActivityTypeStationary;
    } else {
        self.activity = RawMotionActivityTypeUnknown;
    }
}

#pragma mark - Accessors
- (RawMotionActivityType)activity {
    return (RawMotionActivityType)self.model.activity.integerValue;
}

- (void)setActivity:(RawMotionActivityType)activity {
    self.model.activity = @(activity);
}

- (CMMotionActivityConfidence)confidence {
    return self.model.confidence.integerValue;
}

- (void)setConfidence:(CMMotionActivityConfidence)confidence {
    self.model.confidence = @(confidence);
}
@end
