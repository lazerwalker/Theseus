//
//  MotionManager.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "MotionManager.h"
#import "RawMotionActivity.h"
#import "DataProcessor.h"

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

    [self.manager startActivityUpdatesToQueue:NSOperationQueue.mainQueue withHandler:^(CMMotionActivity *activity) {

        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            RawMotionActivity *rawActivity = [[RawMotionActivity alloc] initWithContext:localContext];
            [rawActivity setupWithMotionActivity:activity];
        } completion:nil];
    }];
}

- (void)stopMonitoring {
    [self.manager stopActivityUpdates];
}

- (void)fetchUpdatesWhileInactive {
    if (![CMMotionActivityManager isActivityAvailable]) return;
    NSDate *date = [RawMotionActivity mostRecentTimestamp];

    [self.manager queryActivityStartingFromDate:date toDate:NSDate.date toQueue:self.operationQueue withHandler:^(NSArray *activities, NSError *error) {

        if (error) {
            NSLog(@"MOTION ERROR ================> %@", error);
            return;
        }

        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            for (CMMotionActivity *activity in activities) {
                RawMotionActivity *rawActivity = [[RawMotionActivity alloc] initWithContext:localContext];
                [rawActivity setupWithMotionActivity:activity];
            }
        } completion:^(BOOL success, NSError *error) {
            if (success) {
                [[DataProcessor sharedInstance] processNewData];
            }
        }];
    }];
}
@end
