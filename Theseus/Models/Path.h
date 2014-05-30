//
//  Path.h
//  Theseus
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

@interface Path : TimedEvent

@property (nonatomic, strong) NSSet *locations;
@property (nonatomic, strong) RawMotionActivity *activity;
@property (nonatomic, strong) Stop *stop;

@property (nonatomic, readonly) MovementType type;
@property (nonatomic, readonly) NSString *typeString;

- (void)addLocations:(NSArray *)locations;

@end
