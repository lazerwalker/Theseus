//
//  RawMotionActivity.h
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

typedef NS_ENUM(NSUInteger, RawMotionActivityType) {
    RawMotionActivityTypeUnknown,
    RawMotionActivityTypeStationary,
    RawMotionActivityTypeWalking,
    RawMotionActivityTypeRunning,
    RawMotionActivityTypeAutomotive
};

@import CoreMotion;

@interface RawMotionActivity : NSObject

@property (nonatomic) NSDate* timestamp;
@property (nonatomic) RawMotionActivityType activity;
@property (nonatomic) CMMotionActivityConfidence confidence;

- (void)setupWithMotionActivity:(CMMotionActivity *)activity;

// MagicalRecord
+ (id) MR_createInContext:(NSManagedObjectContext *)context;
+ (id) MR_findFirstOrderedByAttribute:(NSString *)attribute ascending:(BOOL)ascending;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

@end
