//
//  RawDataPoint.h
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@protocol CDRawDataPoint;

@interface RawDataPoint : NSObject

+ (Class)modelClass;

@property (nonatomic) NSDate *timestamp;
@property (nonatomic) NSManagedObject<CDRawDataPoint> *model;

- (id)initWithContext:(NSManagedObjectContext *)context;
- (id)initWithModel:(NSManagedObject<CDRawDataPoint> *)model;
- (id)initWithModel:(NSManagedObject<CDRawDataPoint> *)model
            context:(NSManagedObjectContext *)context;

// MagicalRecord
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

@end
