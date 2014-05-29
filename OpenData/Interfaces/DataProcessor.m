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
#import "Path.h"
#import "UntrackedPeriod.h"

NSString *DataProcessorDidFinishProcessingNotification = @"DataProcessorDidFinishProcessingNotification";

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

- (NSDate *)beginningOfDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    calendar.timeZone = [NSTimeZone localTimeZone];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateForNDaysAgo:(NSInteger)daysAgo {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    calendar.timeZone = [NSTimeZone localTimeZone];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:NSDate.date];
    components.day -= daysAgo;
    return [calendar dateFromComponents:components];
}

- (NSArray *)eventsForDaysAgo:(NSInteger)daysAgo {
    NSPredicate *onlyRealPaths = [NSPredicate predicateWithFormat:@"(stop = nil)"];

    NSDate *startOfDay = [self dateForNDaysAgo:daysAgo];
    NSDate *endOfDay = [self dateForNDaysAgo:daysAgo-1];
    NSPredicate *day = [NSPredicate predicateWithFormat:@"(startTime > %@) AND (endTime < %@)", startOfDay, endOfDay];

    NSArray *stops = [Stop MR_findAllSortedBy:@"startTime" ascending:YES withPredicate:day];
    NSArray *paths = [Path MR_findAllSortedBy:@"startTime" ascending:YES withPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[day, onlyRealPaths]]];
    NSArray *untrackedPeriods = [UntrackedPeriod MR_findAllSortedBy:@"startTime" ascending:YES withPredicate:day];

    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *allObjects = [[[stops arrayByAddingObjectsFromArray:paths] arrayByAddingObjectsFromArray:untrackedPeriods] sortedArrayUsingDescriptors:@[descriptor]];

    return allObjects;
}

- (NSArray *)allEvents {
    NSPredicate *onlyRealPaths = [NSPredicate predicateWithFormat:@"(stop = nil)"];

    NSArray *stops = [Stop MR_findAllSortedBy:@"startTime" ascending:YES];
    NSArray *paths = [Path MR_findAllSortedBy:@"startTime" ascending:YES withPredicate:onlyRealPaths];
    NSArray *untrackedPeriods = [UntrackedPeriod MR_findAllSortedBy:@"startTime" ascending:YES];

    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *allObjects = [[[stops arrayByAddingObjectsFromArray:paths] arrayByAddingObjectsFromArray:untrackedPeriods] sortedArrayUsingDescriptors:@[descriptor]];

    return allObjects;
}

- (NSArray *)allRawData {
    NSArray *motionEvents = [RawMotionActivity MR_findAllSortedBy:@"timestamp" ascending:YES];
    NSArray *locationEvents = [RawLocation MR_findAllSortedBy:@"timestamp" ascending:YES];

    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    NSArray *allObjects = [[motionEvents arrayByAddingObjectsFromArray:locationEvents] sortedArrayUsingDescriptors:@[descriptor]];
    return allObjects;
}

- (void)processNewData {
    [OpenData showNetworkActivitySpinner];
    [self.operationQueue addOperationWithBlock:^{
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            TimedEvent *previousEvent = ({
                NSPredicate *onlyRealPaths = [NSPredicate predicateWithFormat:@"(stop = nil)"];
                NSArray *stops = [Stop MR_findAllSortedBy:@"startTime" ascending:YES inContext:localContext];
                NSArray *paths = [Path MR_findAllSortedBy:@"startTime" ascending:YES withPredicate:onlyRealPaths inContext:localContext];
                NSArray *untrackedPeriods = [UntrackedPeriod MR_findAllSortedBy:@"startTime" ascending:YES inContext:localContext];

                NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
                NSArray *allObjects = [[[stops arrayByAddingObjectsFromArray:paths] arrayByAddingObjectsFromArray:untrackedPeriods] sortedArrayUsingDescriptors:@[descriptor]];

                allObjects.lastObject;
            });

            NSPredicate *predicate;
            if (previousEvent && previousEvent.startTime) {
                NSDate *startDate = [self beginningOfDay:previousEvent.startTime];
                predicate = [NSPredicate predicateWithFormat:@"timestamp >= %@", startDate];

                NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"startTime >= %@", startDate];
                [self removeAllProcessedDataWithPredicate:deletePredicate inContext:localContext];
            }
            
            NSArray *locationArray = [RawLocation MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:predicate inContext:localContext];

            NSArray *motionArray = [RawMotionActivity MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:predicate inContext:localContext];

            NSArray *array = [locationArray arrayByAddingObjectsFromArray:motionArray];
            
            [self processArray:array previousEvent:previousEvent withContext:localContext];
        }];

        [OpenData hideNetworkActivitySpinner];
        [[NSNotificationCenter defaultCenter] postNotificationName:DataProcessorDidFinishProcessingNotification object:self];
    }];
}

- (void)reprocessDataWithCompletion:(void (^)(BOOL, NSError *))completion {
    [OpenData showNetworkActivitySpinner];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [self removeAllProcessedDataWithContext:localContext];

        NSArray *array = [RawLocation MR_findAllSortedBy:@"timestamp" ascending:YES inContext:localContext];
        array = [array arrayByAddingObjectsFromArray:
                 [RawMotionActivity MR_findAllSortedBy:@"timestamp" ascending:YES inContext:localContext]];

        [self processArray:array withContext:localContext];

    } completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, error);
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:DataProcessorDidFinishProcessingNotification object:self];
        [OpenData hideNetworkActivitySpinner];
    }];
}

- (void)reprocessData {
    [self reprocessDataWithCompletion:nil];
}


#pragma mark - Private
- (void)removeAllProcessedDataWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context {
    NSArray *stops = [Stop MR_findAllSortedBy:nil ascending:NO withPredicate:predicate inContext:context];
    for (Stop *stop in stops) {
        [stop destroy];
    }

    NSArray *movementPaths = [Path MR_findAllSortedBy:nil ascending:NO withPredicate:predicate inContext:context];
    for (Path *path in movementPaths) {
        [path destroy];
    }

    NSArray *untrackedPeriods = [UntrackedPeriod MR_findAllSortedBy:nil ascending:NO withPredicate:predicate inContext:context];
    for (UntrackedPeriod *period in untrackedPeriods) {
        [period destroy];
    }
}

- (void)removeAllProcessedDataWithContext:(NSManagedObjectContext *)context {
    NSArray *stops = [Stop MR_findAllInContext:context];
    for (Stop *stop in stops) {
        [stop destroy];
    }

    NSArray *movementPaths = [Path MR_findAllInContext:context];
    for (Path *path in movementPaths) {
        [path destroy];
    }

    NSArray *untrackedPeriods = [UntrackedPeriod MR_findAllInContext:context];
    for (UntrackedPeriod *period in untrackedPeriods) {
        [period destroy];
    }
}

- (void)processArray:(NSArray *)array withContext:(NSManagedObjectContext *)localContext {
    [self processArray:array previousEvent:nil withContext:localContext];
}

- (void)processArray:(NSArray *)array previousEvent:(TimedEvent *)previousObject withContext:(NSManagedObjectContext *)localContext {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    array = [array sortedArrayUsingDescriptors:@[descriptor]];

    RawMotionActivity *previousActivity;

    NSMutableArray *stops = [NSMutableArray new];
    NSMutableArray *paths = [NSMutableArray new];

    NSMutableArray *currentObjects = [NSMutableArray new];

    if (previousObject) {
        if ([previousObject isKindOfClass:Stop.class]) {
            [stops addObject:previousObject];
            previousActivity = ({
                Stop *stop = (Stop *)previousObject;
                NSSet *movementPaths = stop.movementPaths;
                NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"endTime" ascending:NO];
                NSArray *sortedPaths = [movementPaths sortedArrayUsingDescriptors:@[descriptor]];
                [(Path *)sortedPaths.firstObject activity];
            });
        } else if ([previousObject isKindOfClass:Path.class]) {
            [paths addObject:previousObject];
            previousActivity = [(Path *)previousActivity activity];
        }
    }

    for (id obj in array) {
        if ([obj isKindOfClass:RawLocation.class]) {
            [currentObjects addObject:obj];
        } else if ([obj isKindOfClass:RawMotionActivity.class]){
            RawMotionActivity *activity = (RawMotionActivity *)obj;
            if (!(previousActivity.activity == activity.activity)) {
                if (currentObjects.count == 0) {
                    previousActivity = obj;
                    continue;
                }
                if (previousActivity.activity == RawMotionActivityTypeStationary) {
                    Stop *stop = [[Stop alloc] initWithContext:localContext];
                    [stop setupWithLocations:currentObjects];
                    stop.startTime = previousActivity.timestamp;
                    stop.endTime = activity.timestamp;

                    Stop *previousStop = stops.lastObject;
                    if ([stop isSameLocationAs:stops.lastObject]) {
                        Path *previousPath = paths.lastObject;
                        if (previousPath) {
                            [previousStop addPath:previousPath];
                            [paths removeLastObject];
                        }
                        [previousStop mergeWithStop:stop];
                        [stop destroy];
                    } else {
                        [stops addObject:stop];
                    }
                } else if (activity.activity == RawMotionActivityTypeStationary) {
                    Path *path = [[Path alloc] initWithContext:localContext];

                    path.locations = [NSSet setWithArray:currentObjects];
                    path.activity = previousActivity;

                    path.startTime = previousActivity.timestamp;
                    path.endTime = activity.timestamp;
                    [paths addObject:path];
                } else {
                    Path *previousPath = paths.lastObject;
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
     TimedEvent *previousObj;
     NSMutableArray *objectsToRemove = [NSMutableArray new];

     for (TimedEvent *obj in allObjects) {
        if (obj.duration < 60.0) {
            [objectsToRemove addObject:obj];
            if (previousObj) {
                previousObj.endTime = [previousObj.endTime laterDate:obj.endTime];
            }

            [obj destroy];
        } else {
            previousObj = obj;
        }
    }
    [allObjects removeObjectsInArray:objectsToRemove];

    // Add untracked periods when gaps still remain
    NSMutableArray *untrackedPeriods = [NSMutableArray new];
    previousObj = nil;
    for (TimedEvent *obj in allObjects) {
        if (previousObj && fabsf([previousObj.endTime timeIntervalSinceDate:obj.startTime]) > 120) {
            UntrackedPeriod *time = [[UntrackedPeriod alloc] initWithContext:localContext];
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
    for (TimedEvent *obj in allObjects) {
        if (previousObj && obj.class == previousObj.class) {
            [objectsToRemove addObject:obj];
            previousObj.startTime = [previousObj.startTime earlierDate:obj.startTime];
            previousObj.endTime = [previousObj.endTime laterDate:obj.endTime];
            if ([obj isKindOfClass:Path.class]) {
                // TODO: This discards activity data.
                [(Path *)previousObj addLocations:[[(Path *)previousObj locations] allObjects]];
            } else if ([obj isKindOfClass:Stop.class]) {
                [(Stop *)previousObj mergeWithStop:(Stop *)obj];
            }
            [obj destroy];
        }
        previousObj = obj;
    }
    [allObjects removeObjectsInArray:objectsToRemove];
}

@end
