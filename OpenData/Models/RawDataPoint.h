//
//  RawDataPoint.h
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@protocol _RawDataPoint;

@interface RawDataPoint : NSObject

+ (Class)modelClass;

@property (nonatomic) NSDate *timestamp;
@property (nonatomic) NSManagedObject<_RawDataPoint> *model;

- (id)initWithContext:(NSManagedObjectContext *)context;
- (id)initWithModel:(NSManagedObject<_RawDataPoint> *)model;
- (id)initWithModel:(NSManagedObject<_RawDataPoint> *)model
            context:(NSManagedObjectContext *)context;

// MagicalRecord
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

@end
