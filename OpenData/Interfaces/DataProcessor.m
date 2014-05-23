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

NSString * const DataProcessorDidFinishProcessingNotification = @"DataProcessorDidFinishProcessingNotification";

@interface DataProcessor ()

@property (nonatomic) NSArray *thePaths;
@property (nonatomic) NSArray *theStops;

@property (nonatomic) NSOperationQueue *operationQueue;
@end

@implementation DataProcessor

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self new];
    });

    return _sharedInstance;
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterShortStyle;
    });

    return _dateFormatter;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.operationQueue = [NSOperationQueue new];

    return self;
}
- (NSDate *)dateForNDaysAgo:(NSInteger)daysAgo {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:NSDate.date];
    components.day -= daysAgo;
    return [calendar dateFromComponents:components];
}

- (void)fetchDataForDaysAgo:(NSInteger)daysAgo completion:(DataProcessorCompletionBlock)completion {
    NSPredicate *onlyRealPaths = [NSPredicate predicateWithFormat:@"(stop = nil)"];

    NSDate *startOfDay = [self dateForNDaysAgo:daysAgo];
    NSDate *endOfDay = [self dateForNDaysAgo:daysAgo-1];
    NSPredicate *day = [NSPredicate predicateWithFormat:@"(startTime > %@) AND (endTime < %@)", startOfDay, endOfDay];

    NSArray *stops = [Stop MR_findAllSortedBy:@"startTime" ascending:YES withPredicate:day];
    NSArray *paths = [MovementPath MR_findAllSortedBy:@"startTime" ascending:YES withPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[day, onlyRealPaths]]];
    NSArray *untrackedPeriods = [UntrackedPeriod MR_findAllSortedBy:@"startTime" ascending:YES withPredicate:day];

    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *allObjects = [[[stops arrayByAddingObjectsFromArray:paths] arrayByAddingObjectsFromArray:untrackedPeriods] sortedArrayUsingDescriptors:@[descriptor]];

    if (completion) {
        completion(allObjects, stops, paths, untrackedPeriods);
    }
}

- (void)processNewData {
    [self.operationQueue addOperationWithBlock:^{
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"(movementPath == nil) AND (stop == nil)"];
            NSArray *locationArray = [RawLocation MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:locationPredicate inContext:localContext];

            NSPredicate *motionPredicate = [NSPredicate predicateWithFormat:@"movementPath == nil"];
            NSArray *motionArray = [RawMotionActivity MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:motionPredicate inContext:localContext];

            NSArray *array = [locationArray arrayByAddingObjectsFromArray:motionArray];
            [self processArray:array withContext:localContext];
        }];

        [[NSNotificationCenter defaultCenter] postNotificationName:DataProcessorDidFinishProcessingNotification object:self];
    }];
}


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
    NSPredicate *onlyRealPaths = [NSPredicate predicateWithFormat:@"(stop = nil)"];
    NSArray *stops = [Stop MR_findAllSortedBy:@"startTime" ascending:YES];
    NSArray *paths = [MovementPath MR_findAllSortedBy:@"startTime" ascending:YES withPredicate:onlyRealPaths];
    NSArray *untrackedPeriods = [UntrackedPeriod MR_findAllSortedBy:@"startTime" ascending:YES];

    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *allObjects = [[[stops arrayByAddingObjectsFromArray:paths] arrayByAddingObjectsFromArray:untrackedPeriods] sortedArrayUsingDescriptors:@[descriptor]];

    if (completion) {
        completion(allObjects, stops, paths, untrackedPeriods);
    }
}

#pragma mark - Private
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
                    stop.startTime = previousActivity.timestamp;
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

                    path.startTime = previousActivity.timestamp;
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


    NSSortDescriptor *startTimeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSMutableArray *allObjects = [[[stops arrayByAddingObjectsFromArray:paths]
                                   sortedArrayUsingDescriptors:@[startTimeDescriptor]]
                                  mutableCopy];

    // Fold too-short events into the previous ones
     id<TimedEvent> previousObj;
     NSMutableArray *objectsToRemove = [NSMutableArray new];

     for (NSManagedObject<TimedEvent> *obj in allObjects) {
        if (obj.duration < 60.0) {
            [objectsToRemove addObject:obj];
            if (previousObj) {
                previousObj.endTime = [previousObj.endTime laterDate:obj.endTime];
            }

            [obj MR_deleteInContext:localContext];
        } else {
            previousObj = obj;
        }
    }
    [allObjects removeObjectsInArray:objectsToRemove];

    // Add untracked periods when gaps still remain
    NSMutableArray *untrackedPeriods = [NSMutableArray new];
    previousObj = nil;
    for (id<TimedEvent> obj in allObjects) {
        if (previousObj && fabsf([previousObj.endTime timeIntervalSinceDate:obj.startTime]) > 120) {
            UntrackedPeriod *time = [UntrackedPeriod MR_createInContext:localContext];
            time.startTime = previousObj.endTime;
            time.endTime = [obj startTime];
            [untrackedPeriods addObject:time];
        }
        previousObj = obj;
    }

    // If two subsequent events are of the same type, combine 'em.
    allObjects = [[[allObjects arrayByAddingObjectsFromArray:untrackedPeriods] sortedArrayUsingDescriptors:@[startTimeDescriptor]] mutableCopy];
    objectsToRemove = [NSMutableArray new];
    previousObj = nil;
    for (NSManagedObject<TimedEvent> *obj in allObjects) {
        if (previousObj && obj.class == previousObj.class) {
            [objectsToRemove addObject:obj];
            previousObj.endTime = [previousObj.endTime laterDate:obj.endTime];
            if ([obj isKindOfClass:MovementPath.class]) {
                // TODO: This discards activity data.
                [(MovementPath *)previousObj addLocations:[[(MovementPath *)previousObj locations] allObjects]];
            } else if ([obj isKindOfClass:Stop.class]) {
                [(Stop *)previousObj mergeWithStop:(Stop *)obj];
            }
            [obj MR_deleteInContext:localContext];
        }
        previousObj = obj;
    }
    [allObjects removeObjectsInArray:objectsToRemove];
}

@end
