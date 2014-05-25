//
//  _Path.h
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "_TimedEvent.h"

@class CDRawMotionActivity;
@class CDStop;

@interface CDPath : NSManagedObject<_TimedEvent>

@property (nonatomic, strong) NSSet *locations;
@property (nonatomic, strong) CDRawMotionActivity *activity;
@property (nonatomic, strong) CDStop *stop;

@end
