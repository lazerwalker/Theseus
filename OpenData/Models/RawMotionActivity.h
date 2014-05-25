//
//  RawMotionActivity.h
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

typedef NS_ENUM(NSUInteger, RawMotionActivityType) {
    RawMotionActivityTypeUnknown,
    RawMotionActivityTypeStationary,
    RawMotionActivityTypeWalking,
    RawMotionActivityTypeRunning,
    RawMotionActivityTypeAutomotive
};

#import "RawDataPoint.h"

@import CoreMotion;

@interface RawMotionActivity : RawDataPoint

+ (NSDate *)mostRecentTimestamp;

@property (nonatomic) RawMotionActivityType activity;
@property (nonatomic) CMMotionActivityConfidence confidence;

- (void)setupWithMotionActivity:(CMMotionActivity *)activity;

@end
