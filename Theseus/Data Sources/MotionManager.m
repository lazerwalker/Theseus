//
//  MotionManager.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/12/14.
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
            [[DataProcessor sharedInstance] processNewData];
        }];
    }];
}
@end
