//
//  TimedEvent.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/25/14.
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

#import "TimedEvent.h"
#import "CDTimedEvent.h"

#import <Asterism.h>

@interface TimedEvent ()
@property (nonatomic) NSString *eventType; // Exists solely for Mantle
@end

@implementation TimedEvent

+ (Class)modelClass {
    @throw @"Not implemented";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"model": NSNull.null,
             @"context": NSNull.null,
             @"duration": NSNull.null};
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

+ (NSValueTransformer *)startTimeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)endTimeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}


- (id)init {
    if (!(self = [super init])) return nil;
    self.model = [self.class.modelClass MR_createEntity];
    return self;
}

- (id)initWithContext:(NSManagedObjectContext *)context {
    if (!(self = [super init])) return nil;

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertAction = nil;
    notification.alertBody = [NSString stringWithFormat:@"Initializing with context: %@", context];
    [UIApplication.sharedApplication presentLocalNotificationNow:notification];

    self.context = context;
    self.model = [self.class.modelClass MR_createInContext:context];
    return self;
}

- (id)initWithCDModel:(NSManagedObject<CDTimedEvent> *)model {
    if (!model) return nil;
    if (!(self = [super init])) return nil;
    self.model = model;
    return self;
}

- (id)initWithCDModel:(NSManagedObject<CDTimedEvent> *)model
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

#pragma mark -
- (NSString *)eventType {
    return NSStringFromClass(self.class);
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
+ (NSArray *)MR_findAll {
    NSArray *array = [self.modelClass MR_findAll];
    return ASTMap(array, ^id(id<CDTimedEvent> obj) {
        return [[self alloc] initWithCDModel:obj];
    });
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending {
    NSArray *array = [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending];
    return ASTMap(array, ^id(id<CDTimedEvent> obj) {
        return [[self alloc] initWithCDModel:obj];
    });
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm {
    NSArray *array = [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm];
    return ASTMap(array, ^id(id<CDTimedEvent> obj) {
        return [[self alloc] initWithCDModel:obj];
    });
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context {
    NSArray *array = [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending inContext:context];

    return ASTMap(array, ^id(id<CDTimedEvent> obj) {
        return [[self alloc] initWithCDModel:obj
                                   context:context];
    });

}

+ (NSArray *) MR_findAllInContext:(NSManagedObjectContext *)context {
    NSArray *array = [self.modelClass MR_findAllInContext:context];
    return ASTMap(array, ^id(id<CDTimedEvent> obj) {
        return [[self alloc] initWithCDModel:obj
                                   context:context];
    });
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context {
    NSArray *array = [self.modelClass MR_findAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm inContext:context];
    return ASTMap(array, ^id(id<CDTimedEvent> obj) {
        return [[self alloc] initWithCDModel:obj
                                   context:context];
    });
}

+ (instancetype)MR_findWithStartTime:(NSDate *)date {
    return [self.modelClass MR_findFirstByAttribute:@"startDate" withValue:date];
}

- (BOOL) MR_deleteInContext:(NSManagedObjectContext *)context {
    return [self.model MR_deleteInContext:context];
}

- (BOOL) MR_deleteEntity {
    return [self.model MR_deleteEntity];
}

@end
