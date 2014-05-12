//
//  MotionManager.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "MotionManager.h"
#import "LocationList.h"
@import CoreMotion;

@interface MotionManager ()
@property (strong, nonatomic) CMMotionActivityManager *manager;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@end


@implementation MotionManager

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.manager = [CMMotionActivityManager new];
    self.operationQueue = [NSOperationQueue new];

    return self;
}

- (void)startMonitoring {
    if (![CMMotionActivityManager isActivityAvailable]) return;

    [self.manager startActivityUpdatesToQueue:self.operationQueue withHandler:^(CMMotionActivity *activity) {
        LocationList *list = [LocationList loadFromDisk];
        [list addActivities:@[activity]];
    }];
}

- (void)stopMonitoring {
    [self.manager stopActivityUpdates];
}

- (void)fetchUpdatesWhileInactive {
    if (![CMMotionActivityManager isActivityAvailable]) return;

    LocationList *list = [LocationList loadFromDisk];
    NSDate *date = [list.activities.lastObject startDate];
    if (!date) date = [NSDate distantPast];

    [self.manager queryActivityStartingFromDate:date toDate:NSDate.date toQueue:self.operationQueue withHandler:^(NSArray *activities, NSError *error) {

        if (error) {
            NSLog(@"================> %@", error);
            return;
        }
        
        LocationList *list = [LocationList loadFromDisk];
        [list addActivities:activities];
    }];
}
@end
