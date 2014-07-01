//
//  StepManager.m
//  Theseus
//
//  Created by Michael Walker on 6/29/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
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

#import "StepManager.h"
#import "StepCount.h"
#import "CDStepCount.h"

@import CoreMotion;

extern NSString *TheseusDidProcessNewDataStep;

@interface StepManager ()

@property (nonatomic, strong) CMStepCounter *manager; // TODO: Replace with CMPedometer
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation StepManager

- (instancetype)init {
    if (!(self = [super init])) return nil;

    self.manager = [[CMStepCounter alloc] init];
    self.queue = [[NSOperationQueue alloc] init];

    return self;
}

- (void)startMonitoring {
    [self.manager startStepCountingUpdatesToQueue:self.queue
                                         updateOn:1
                                      withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
                                          NSDate *date = timestamp.beginningOfDay;
                                          [self processStepsForDate:date];
                                      }];
}

- (void)stopMonitoring {
    [self.manager stopStepCountingUpdates];
}

- (void)fetchUpdatesWhileInactive {
    for (int daysAgo=0; daysAgo<7; daysAgo++) {
        NSDate *date = [[NSDate alloc] initWithDaysAgo:daysAgo];
        [self processStepsForDate:date];
    }
}

- (void)processStepsForDate:(NSDate *)date {
    date = date.beginningOfDay;
    [self.manager queryStepCountStartingFrom:date
                                          to:date.endOfDay
                                     toQueue:self.queue
                                 withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                     if (!error && numberOfSteps > 0) {
                                         [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                                             StepCount *step = [self stepCountForDate:date context:localContext];

                                             step.count = numberOfSteps;
                                             step.date = date;
                                         } completion:^(BOOL success, NSError *error) {
                                             if (!success) return;
                                             [[NSNotificationCenter defaultCenter] postNotificationName:TheseusDidProcessNewDataStep object:date];
                                         }];
                                     }
                                 }];
}

- (StepCount *)stepCountForDate:(NSDate *)date {
    NSPredicate *day = [NSPredicate predicateWithFormat:@"date = %@", date];
    CDStepCount *step = [CDStepCount MR_findFirstWithPredicate:day];

    if (step) {
        return [[StepCount alloc] initWithCDModel:step];
    } else {
        return [StepCount new];
    }
}

#pragma mark - 
- (StepCount *)stepCountForDate:(NSDate *)date context:(NSManagedObjectContext *)context {
    NSPredicate *day = [NSPredicate predicateWithFormat:@"date = %@", date];
    CDStepCount *step = [CDStepCount MR_findFirstWithPredicate:day inContext:context];

    if (step) {
        return [[StepCount alloc] initWithCDModel:step];
    } else {
        return [[StepCount alloc] initWithContext:context];
    }
}
@end
