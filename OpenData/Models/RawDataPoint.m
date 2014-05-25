//
//  RawDataPoint.m
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "RawDataPoint.h"
#import "CDRawDataPoint.h"

#import <Asterism.h>

@interface RawDataPoint ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation RawDataPoint

+ (Class)modelClass {
    @throw @"Not implemented";
}

- (id)initWithContext:(NSManagedObjectContext *)context {
    if (!(self = [super init])) return nil;
    self.context = context;
    self.model = [self.class.modelClass MR_createInContext:context];
    return self;
}

- (id)initWithModel:(NSManagedObject<CDRawDataPoint> *)model {
    if (!model) return nil;
    if (!(self = [super init])) return nil;
    self.model = model;
    return self;
}

- (id)initWithModel:(NSManagedObject<CDRawDataPoint> *)model
            context:(NSManagedObjectContext *)context {
    if (!model) return nil;
    if (!(self = [super init])) return nil;
    self.model = model;
    self.context = context;
    return self;
}

#pragma mark - Accessors
- (NSDate *)timestamp {
    return self.model.timestamp;
}

- (void)setTimestamp:(NSDate *)timestamp {
    self.model.timestamp = timestamp;
}

#pragma mark - MagicalRecord
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context {
    NSArray *array = [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm inContext:context];
    return ASTMap(array, ^id(id<CDRawDataPoint> obj) {
        return [[self alloc] initWithModel:obj context:context];
    });
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context {
    NSArray *array = [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending inContext:context];
    return ASTMap(array, ^id(id<CDRawDataPoint> obj) {
        return [[self alloc] initWithModel:obj context:context];
    });
}
@end
