//
//  TimedEvent.h
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/22/14.
//  Copyright (c) 2014 Mike Lazer-Walker
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>

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
+ (instancetype)MR_findWithStartTime:(NSDate *)date;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context;
+ (NSArray *) MR_findAll;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

@end
