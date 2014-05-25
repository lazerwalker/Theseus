//
//  Path.h
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

typedef NS_ENUM(NSUInteger, MovementType) {
    MovementTypeUnknown,
    MovementTypeWalking,
    MovementTypeRunning,
    MovementTypeBiking,
    MovementTypeTransit
};

#import "TimedEvent.h"

@class Stop;
@class RawMotionActivity;

@interface Path : NSObject<TimedEvent>

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSSet *locations;
@property (nonatomic, strong) RawMotionActivity *activity;
@property (nonatomic, strong) Stop *stop;

@property (nonatomic, readonly) MovementType type;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) NSString *typeString;

- (void)addLocations:(NSArray *)locations;

// MagicalRecord methods to remove
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context;
+ (id) MR_createInContext:(NSManagedObjectContext *)context;
- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context;
- (BOOL) MR_deleteEntity;

@end
