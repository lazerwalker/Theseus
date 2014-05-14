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

- (void)processDataWithCompletion:(void (^)(NSArray *, NSArray *))completion {
    NSArray *array = [[RawLocation MR_findAllSortedBy:@"timestamp" ascending:YES]
                      arrayByAddingObjectsFromArray:
                      [RawMotionActivity MR_findAllSortedBy:@"timestamp" ascending:YES]];

    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    array = [array sortedArrayUsingDescriptors:@[descriptor]];

    RawMotionActivity *previousActivity;

    NSMutableArray *annotations = [NSMutableArray new];
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
                    Stop *stop = [[Stop alloc] initWithLocations:currentObjects];
                    stop.endTime = activity.timestamp;
                    [annotations addObject:stop];
                } else {
                    CLLocationCoordinate2D* pointArr = malloc(sizeof(CLLocationCoordinate2D) * currentObjects.count);

                    NSUInteger idx = 0;
                    for (RawLocation *location in currentObjects) {
                        pointArr[idx] = location.coordinate;
                        idx++;
                    }

                    MovementPath *path = [MovementPath polylineWithCoordinates:pointArr count:currentObjects.count];

                    if (activity.activityType == RawMotionActivityTypeWalking) {
                        path.type = MovementTypeWalking;
                    } else if (activity.activityType == RawMotionActivityTypeRunning) {
                        path.type = MovementTypeRunning;
                    } else if (activity.activityType == RawMotionActivityTypeAutomotive) {
                        path.type = MovementTypeTransit;
                    }

                    path.startTime = [(RawLocation *)currentObjects.firstObject timestamp];
                    path.endTime = activity.timestamp;
                    [paths addObject:path];
                }
                currentObjects = [NSMutableArray new];
            }

            previousActivity = obj;
        }
    }
    if (completion) {
        completion(annotations, paths);
    }
}

@end
