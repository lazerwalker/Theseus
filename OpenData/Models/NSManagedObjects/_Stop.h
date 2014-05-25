//
//  _Stop.h
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "_TimedEvent.h"

@class _MovementPath;
@class _Venue;

@interface _Stop : NSManagedObject<_TimedEvent>

@property (nonatomic) NSSet *locations;
@property (nonatomic) NSSet *movementPaths;
@property (nonatomic) NSNumber *venueConfirmed;
@property (nonatomic) _Venue *venue;

@end
