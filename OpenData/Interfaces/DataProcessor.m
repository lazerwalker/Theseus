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
}

- (void)processDataWithCompletion:(void (^)(NSArray *, NSArray *))completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [self removeAllProcessedDataWithContext:localContext];

        NSArray *array = [RawLocation MR_findAllSortedBy:@"timestamp" ascending:YES inContext:localContext];

        array = [array arrayByAddingObjectsFromArray:
          [RawMotionActivity MR_findAllSortedBy:@"timestamp" ascending:YES inContext:localContext]];

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
                    } else {
                        MovementPath *path = [MovementPath MR_createInContext:localContext];

                        path.locations = [NSSet setWithArray:currentObjects];
                        path.activity = previousActivity;

                        path.startTime = [(RawLocation *)currentObjects.firstObject timestamp];
                        path.endTime = activity.timestamp;
                        [paths addObject:path];
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
                [stop MR_deleteEntity];
            }
        }
        [stops removeObjectsInArray:stopsToRemove];
    } completion:^(BOOL success, NSError *error) {
        if (completion) {
            NSArray *stops = [Stop MR_findAllSortedBy:@"startTime" ascending:YES];
            NSArray *paths = [MovementPath MR_findAllSortedBy:@"startTime" ascending:YES];

            completion(stops, paths);
        }
    }];
}

- (void)fetchStaleDataWithCompletion:(void(^)(NSArray *stops, NSArray *paths))completion {
    if (completion) {
        NSArray *stops = [Stop MR_findAllSortedBy:@"startTime" ascending:YES];
        NSArray *paths = [MovementPath MR_findAllSortedBy:@"startTime" ascending:YES];

        completion(stops, paths);
    }
}
@end
