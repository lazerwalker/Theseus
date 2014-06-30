//
//  StepCount.m
//  Theseus
//
//  Created by Michael Walker on 6/30/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "StepCount.h"
#import "CDStepCount.h"

@implementation StepCount

+ (instancetype)forDate:(NSDate *)date {
    NSPredicate *day = [NSPredicate predicateWithFormat:@"date = %@", date];
    CDStepCount *step = [CDStepCount MR_findFirstWithPredicate:day];

    if (step) {
        return [[StepCount alloc] initWithCDModel:step];
    } else {
        return [StepCount new];
    }
}

+ (instancetype)forDate:(NSDate *)date context:(NSManagedObjectContext *)context {
    NSPredicate *day = [NSPredicate predicateWithFormat:@"date = %@", date];
    CDStepCount *step = [CDStepCount MR_findFirstWithPredicate:day inContext:context];

    if (step) {
        return [[StepCount alloc] initWithCDModel:step];
    } else {
        return [[StepCount alloc] initWithContext:context];
    }
}

- (id)initWithCDModel:(CDStepCount *)model {
    if (!model) return nil;
    if (!(self = [super init])) return nil;
    self.model = model;
    return self;
}

- (id)initWithContext:(NSManagedObjectContext *)context {
    if (!(self = [super init])) return nil;
    self.model = [CDStepCount MR_createInContext:context];
    return self;
}

- (id)init {
    if (!(self = [super init])) return nil;
    self.model = [CDStepCount MR_createEntity];
    return self;
}

#pragma mark - Accessors
- (void)setDate:(NSDate *)date {
    self.model.date = date;
}

- (void)setCount:(NSInteger)count {
    self.model.count = @(count);
}

- (NSInteger)count {
    return self.model.count.integerValue;
}

- (NSDate *)date {
    return self.model.date;
}

@end
