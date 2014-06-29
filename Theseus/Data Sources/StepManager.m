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
@import CoreMotion;

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

- (void)stepsForDaysAgo:(NSInteger)daysAgo
             completion:(CMStepQueryHandler)completion {
    NSDate *start = [[NSDate alloc] initWithDaysAgo:daysAgo];
    NSDate *end = start.endOfDay;

    [self.manager queryStepCountStartingFrom:start
                                          to:end
                                     toQueue:self.queue
                                 withHandler:completion];
}

@end
