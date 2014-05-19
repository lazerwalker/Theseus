//
//  MovementPath.h
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@import MapKit;

@class RawMotionActivity;

typedef NS_ENUM(NSUInteger, MovementType) {
    MovementTypeUnknown,
    MovementTypeWalking,
    MovementTypeRunning,
    MovementTypeBiking,
    MovementTypeTransit
};

@interface MovementPath : NSManagedObject

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSSet *locations;
@property (nonatomic, strong) RawMotionActivity *activity;

@property (nonatomic, readonly) MovementType type;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) NSString *typeString;

@end
