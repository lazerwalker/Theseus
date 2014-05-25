//
//  TimedEvent.m
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "TimedEvent.h"
#import "CDTimedEvent.h"

#import <Asterism.h>

@implementation TimedEvent

+ (Class)modelClass {
    @throw @"Not implemented";
}

- (id)init {
    if (!(self = [super init])) return nil;
    self.model = [self.class.modelClass MR_createEntity];
    return self;
}

- (id)initWithContext:(NSManagedObjectContext *)context {
    if (!(self = [super init])) return nil;
    self.context = context;
    self.model = [self.class.modelClass MR_createInContext:context];
    return self;
}

- (id)initWithModel:(NSManagedObject<CDTimedEvent> *)model {
    if (!model) return nil;
    if (!(self = [super init])) return nil;
    self.model = model;
    return self;
}

- (id)initWithModel:(NSManagedObject<CDTimedEvent> *)model
            context:(NSManagedObjectContext *)context {
    if (!model) return nil;
    if (!(self = [super init])) return nil;
    self.model = model;
    self.context = context;
    return self;
}

- (BOOL)destroy {
    if (self.context) {
        return [self.model MR_deleteInContext:self.context];
    } else {
        return [self.model MR_deleteEntity];
    }
}


#pragma mark - Accessors
- (NSTimeInterval)duration {
    return [self.endTime timeIntervalSinceDate:self.startTime];
}

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
    NSArray *array = [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm];
    return ASTMap(array, ^id(id<CDTimedEvent> obj) {
        return [[self alloc] initWithModel:obj];
    });
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context {
    NSArray *array = [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending inContext:context];

    return ASTMap(array, ^id(id<CDTimedEvent> obj) {
        return [[self alloc] initWithModel:obj
                                   context:context];
    });

}

+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context {
    NSArray *array = [self.modelClass MR_findAllInContext:context];
    return ASTMap(array, ^id(id<CDTimedEvent> obj) {
        return [[self alloc] initWithModel:obj
                                   context:context];
    });
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context {
    NSArray *array = [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm inContext:context];
    return ASTMap(array, ^id(id<CDTimedEvent> obj) {
        return [[self alloc] initWithModel:obj
                                   context:context];
    });
}

- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context {
    return [self.model MR_deleteInContext:context];
}

- (BOOL) MR_deleteEntity {
    return [self.model MR_deleteEntity];
}

@end
