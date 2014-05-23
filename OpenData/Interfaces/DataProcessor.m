//
//  DataProcessor.m
//  OpenData
//
//  Created by Michael Walker on 5/14/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "DataProcessor.h"
#import "RawLocation.h"
#import "RawMotionActivity.h"
#import "Stop.h"
#import "MovementPath.h"
#import "UntrackedPeriod.h"

@interface DataProcessor ()

@property (nonatomic) NSArray *thePaths;
@property (nonatomic) NSArray *theStops;

@end

@implementation DataProcessor

- (void)removeAllProcessedDataWithContext:(NSManagedObjectContext *)context {
    NSArray *stops = [Stop MR_findAllInContext:context];
    for (Stop *stop in stops) {
        [stop MR_deleteInContext:context];
    }

    NSArray *movementPaths = [MovementPath MR_findAllInContext:context];
    for (MovementPath *path in movementPaths) {
        [path MR_deleteInContext:context];
    }

    NSArray *untrackedPeriods = [UntrackedPeriod MR_findAllInContext:context];
    for (UntrackedPeriod *period in untrackedPeriods) {
        [period MR_deleteInContext:context];
    }
}

- (void)processNewDataWithCompletion:(DataProcessorCompletionBlock)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {

        NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"movementPath == nil AND stop == nil"];
        NSArray *locationArray = [RawLocation MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:locationPredicate inContext:localContext];

        NSPredicate *motionPredicate = [NSPredicate predicateWithFormat:@"movementPath == nil"];
        NSArray *motionArray = [RawMotionActivity MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:motionPredicate inContext:localContext];

        NSArray *array = [locationArray arrayByAddingObjectsFromArray:motionArray];
        [self processArray:array withContext:localContext];
    } completion:^(BOOL success, NSError *error) {
        [self fetchStaleDataWithCompletion:completion];
    }];}

- (void)reprocessDataWithCompletion:(DataProcessorCompletionBlock)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [self removeAllProcessedDataWithContext:localContext];

        NSArray *array = [RawLocation MR_findAllSortedBy:@"timestamp" ascending:YES inContext:localContext];
        array = [array arrayByAddingObjectsFromArray:
                 [RawMotionActivity MR_findAllSortedBy:@"timestamp" ascending:YES inContext:localContext]];

        [self processArray:array withContext:localContext];
    } completion:^(BOOL success, NSError *error) {
        [self fetchStaleDataWithCompletion:completion];
    }];
}

- (void)fetchStaleDataWithCompletion:(void(^)(NSArray *allObjects, NSArray *stops, NSArray *paths, NSArray *untrackedPeriods))completion {
    if (completion) {
        NSPredicate *onlyRealPaths = [NSPredicate predicateWithFormat:@"(stop = nil)"];
        NSArray *stops = [Stop MR_findAllSortedBy:@"startTime" ascending:YES];
        NSArray *paths = [MovementPath MR_findAllSortedBy:@"startTime" ascending:YES withPredicate:onlyRealPaths];
        NSArray *untrackedPeriods = [UntrackedPeriod MR_findAllSortedBy:@"startTime" ascending:YES];

        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
        NSArray *allObjects = [[[stops arrayByAddingObjectsFromArray:paths] arrayByAddingObjectsFromArray:untrackedPeriods] sortedArrayUsingDescriptors:@[descriptor]];

        completion(allObjects, stops, paths, untrackedPeriods);
    }
}

#pragma mark - Private
- (void)processArray:(NSArray *)array withContext:(NSManagedObjectContext *)localContext {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    array = [array sortedArrayUsingDescriptors:@[descriptor]];

    RawMotionActivity *previousActivity;

    NSMutableArray *stops = [NSMutableArray new];
    NSMutableArray *paths = [NSMutableArray new];

    NSMutableArray *currentObjects = [NSMutableArray new];

    for (id obj in array) {
        if ([obj isKindOfClass:RawLocation.class]) {
            [currentObjects addObject:obj];
        } else if ([obj isKindOfClass:RawMotionActivity.class]){
            RawMotionActivity *activity = (RawMotionActivity *)obj;
            if (!(previousActivity.activityType == activity.activityType)) {
                if (currentObjects.count == 0) continue;
                if (previousActivity.activityType == RawMotionActivityTypeStationary) {
                    Stop *stop = [Stop MR_createInContext:localContext];
                    [stop setupWithLocations:currentObjects];
                    stop.endTime = activity.timestamp;

                    Stop *previousStop = stops.lastObject;
                    if ([stop isSameLocationAs:stops.lastObject]) {
                        MovementPath *previousPath = paths.lastObject;
                        [previousStop addMovementPath:previousPath];
                        [paths removeLastObject];
                        [previousStop mergeWithStop:stop];
                        [stop MR_deleteEntity];
                    } else {
                        [stops addObject:stop];
                    }
                } else if (activity.activityType == RawMotionActivityTypeStationary) {
                    MovementPath *path = [MovementPath MR_createInContext:localContext];

                    path.locations = [NSSet setWithArray:currentObjects];
                    path.activity = previousActivity;

                    path.startTime = [(RawLocation *)currentObjects.firstObject timestamp];
                    path.endTime = activity.timestamp;
                    [paths addObject:path];
                } else {
                    MovementPath *previousPath = paths.lastObject;
                    [previousPath addLocations:currentObjects];
                    previousPath.endTime = activity.timestamp;
                }
                currentObjects = [NSMutableArray new];
            }

            previousActivity = obj;
        }
    }

    NSMutableArray *stopsToRemove = [NSMutableArray new];
    for (Stop *stop in stops) {
        if (stop.duration < 60.0) {
            [stopsToRemove addObject:stop];
            [stop MR_deleteInContext:localContext];
        }
    }
    [stops removeObjectsInArray:stopsToRemove];

    NSMutableArray *pathsToRemove = [NSMutableArray new];
    for (MovementPath *path in paths) {
        if (path.duration < 60.0) {
            [pathsToRemove addObject:path];
            [path MR_deleteInContext:localContext];
        }
    }
    [paths removeObjectsInArray:pathsToRemove];

    NSSortDescriptor *startTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *allObjects = [[stops arrayByAddingObjectsFromArray:paths] sortedArrayUsingDescriptors:@[startTimeDescriptor]];
    NSMutableArray *untrackedPeriods = [NSMutableArray new];
    id<TimedEvent> previousObj;
    for (id<TimedEvent> obj in allObjects) {
        if (fabsf([previousObj.endTime timeIntervalSinceDate:obj.startTime]) > 10) {
            UntrackedPeriod *time = [UntrackedPeriod MR_createInContext:localContext];
            time.startTime = previousObj.endTime;
            time.endTime = [obj startTime];
            [untrackedPeriods addObject:time];
        }
        previousObj = obj;
    }
}

@end
