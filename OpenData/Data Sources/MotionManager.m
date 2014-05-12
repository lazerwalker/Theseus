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
@end


@implementation MotionManager

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.manager = [CMMotionActivityManager new];

    return self;
}

- (void)startMonitoring {
    if (![CMMotionActivityManager isActivityAvailable]) return;

    [self.manager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity *activity) {
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
    [self.manager queryActivityStartingFromDate:date toDate:NSDate.date toQueue:NSOperationQueue.mainQueue withHandler:^(NSArray *activities, NSError *error) {

        if (error) {
            NSLog(@"================> %@", error);
            return;
        }
        
        LocationList *list = [LocationList loadFromDisk];
        [list addActivities:activities];
    }];
}
@end
