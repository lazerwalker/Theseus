//
//  TimedEvent.h
//  OpenData
//
//  Created by Michael Walker on 5/22/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Mantle.h>
@protocol CDTimedEvent;

@interface TimedEvent : MTLModel<MTLJSONSerializing>

+ (Class)modelClass;

@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;
@property (nonatomic) NSManagedObject<CDTimedEvent> *model;
@property (nonatomic) NSManagedObjectContext *context;

@property (nonatomic, readonly) NSTimeInterval duration;

- (id)initWithContext:(NSManagedObjectContext *)context;
- (id)initWithCDModel:(NSManagedObject<CDTimedEvent> *)model;
- (id)initWithCDModel:(NSManagedObject<CDTimedEvent> *)model
            context:(NSManagedObjectContext *)context;

- (BOOL)destroy;

// MagicalRecord
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

@end
