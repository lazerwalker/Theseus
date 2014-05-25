//
//  UntrackedPeriod.h
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "TimedEvent.h"

@interface UntrackedPeriod : TimedEvent

// Core data
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context;
+ (id) MR_createInContext:(NSManagedObjectContext *)context;
- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context;

@end
