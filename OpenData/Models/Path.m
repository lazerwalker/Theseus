//
//  Path.m
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "Path.h"
#import "_MovementPath.h"
#import "RawMotionActivity.h"

@interface Path ()
@property (nonatomic, strong) _MovementPath *model;
@end

@implementation Path
+ (Class)modelClass {
    return _MovementPath.class;
}

- (NSTimeInterval)duration {
    return [self.endTime timeIntervalSinceDate:self.startTime];
}

- (NSString *)typeString {
    NSArray *types = @[@"Unknown",
                       @"Walking",
                       @"Running",
                       @"Biking",
                       @"Transit"];
    return types[self.type];
}

- (MovementType)type {
    if (self.activity.activity == RawMotionActivityTypeWalking) {
        return MovementTypeWalking;
    } else if (self.activity.activity == RawMotionActivityTypeRunning) {
        return MovementTypeRunning;
    } else if (self.activity.activity == RawMotionActivityTypeAutomotive) {
        return MovementTypeTransit;
    } else {
        return MovementTypeUnknown;
    }
}

- (void)addLocations:(NSArray *)locations {
    self.locations = [self.locations setByAddingObjectsFromArray:locations];
}

#pragma mark - Core Data Attributes
- (NSDate *)startTime {
    return self.model.startTime;
}

- (void)setStartTime:(NSDate *)startTime {
    self.model.startTime = startTime;
}

- (NSDate *)endTime {
    return self.model.endTime;
}

- (void)setEndTime:(NSDate *)endTime {
    self.model.endTime = endTime;
}

- (NSSet *)locations {
    return self.model.locations;
}

- (_RawMotionActivity *)activity {
    return self.model.activity;
}

- (void)setActivity:(_RawMotionActivity *)activity {
    self.model.activity = activity;
}


#pragma mark - MagicalRecord
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm {
    return [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm];
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context {
    return [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending inContext:context];
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context {
    return [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm inContext:context];
}

+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context {
    return [self.modelClass MR_findAllInContext:context];
}

+ (id) MR_createInContext:(NSManagedObjectContext *)context {
    Path *obj = [self new];
    obj.model = [self.modelClass MR_createInContext:context];
    return obj;
}

- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context {
    return [self.model MR_deleteInContext:context];
}

- (BOOL) MR_deleteEntity {
    return [self.model MR_deleteEntity];
}

@end
