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
