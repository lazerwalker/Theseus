//
//  UntrackedPeriod.m
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "UntrackedPeriod.h"
#import "_UntrackedPeriod.h"

@interface UntrackedPeriod ()
@property (nonatomic, strong) _UntrackedPeriod *model;
@end

@implementation UntrackedPeriod

+ (Class)modelClass {
    return _UntrackedPeriod.class;
}

- (NSTimeInterval)duration {
    return [self.endTime timeIntervalSinceDate:self.startTime];
}

#pragma mark - Core Data
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

#pragma mark - MagicalRecord
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm {
    return [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm];
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context {
    return [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending inContext:context];
}

+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context {
    return [self.modelClass MR_findAllInContext:context];
}

+ (id) MR_createInContext:(NSManagedObjectContext *)context {
    return [self.modelClass MR_createInContext:context];
}

- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context {
    return [self.model MR_deleteInContext:context];
}

@end
