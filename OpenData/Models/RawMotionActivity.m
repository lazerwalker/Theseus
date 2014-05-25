//
//  RawMotionActivity.m
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "RawMotionActivity.h"
#import "_RawMotionActivity.h"

@interface RawMotionActivity ()
@property (nonatomic) _RawMotionActivity *model;
@end

@implementation RawMotionActivity

+ (Class)modelClass {
    return _RawMotionActivity.class;
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

#pragma mark - Core Data accessors
- (NSDate *)timestamp {
    return self.model.timestamp;
}

- (void)setTimestamp:(NSDate *)timestamp {
    self.model.timestamp = timestamp;
}

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

#pragma mark - MagicalRecord
+ (id) MR_createInContext:(NSManagedObjectContext *)context {
    return [self.modelClass MR_createInContext:context];
}

+ (id) MR_findFirstOrderedByAttribute:(NSString *)attribute ascending:(BOOL)ascending {
    return [self.modelClass MR_findFirstOrderedByAttribute:attribute ascending:ascending];
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context {
    return [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm inContext:context];
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context {
    return [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending inContext:context];
}
@end
