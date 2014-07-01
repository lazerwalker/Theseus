//
//  StepCount.h
//  Theseus
//
//  Created by Michael Walker on 6/30/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Mantle.h>

@class CDStepCount;

@interface StepCount : MTLModel

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) CDStepCount *model;

- (id)initWithCDModel:(CDStepCount *)model;
- (id)initWithContext:(NSManagedObjectContext *)context;

@end
