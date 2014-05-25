//
//  _Path.h
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@class _RawMotionActivity;
@class _Stop;

@interface _MovementPath : NSManagedObject

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSSet *locations;
@property (nonatomic, strong) _RawMotionActivity *activity;
@property (nonatomic, strong) _Stop *stop;

@end
