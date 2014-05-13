//
//  MotionManager.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "MotionManager.h"
#import "RawMotionActivity.h"

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
        RawMotionActivity *rawActivity = [RawMotionActivity createWithMotionActivity:activity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }];
}

- (void)stopMonitoring {
    [self.manager stopActivityUpdates];
}

- (void)fetchUpdatesWhileInactive {
    if (![CMMotionActivityManager isActivityAvailable]) return;

    RawMotionActivity *mostRecent = [RawMotionActivity MR_findFirstOrderedByAttribute:@"timestamp" ascending:NO];
    NSDate *date = mostRecent.timestamp ?: [NSDate distantPast];

    [self.manager queryActivityStartingFromDate:date toDate:NSDate.date toQueue:self.operationQueue withHandler:^(NSArray *activities, NSError *error) {

        if (error) {
            NSLog(@"================> %@", error);
            return;
        }
        
        NSMutableArray *rawActivities = [NSMutableArray new];
        for (CMMotionActivity *activity in activities) {
            [rawActivities addObject:[RawMotionActivity createWithMotionActivity:activity]];
        }

        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }];
}
@end
