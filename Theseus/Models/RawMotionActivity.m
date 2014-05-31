//
//  RawMotionActivity.m
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
