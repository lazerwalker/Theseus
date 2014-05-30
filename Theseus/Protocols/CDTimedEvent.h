//
//  _TimedEvent.h
//  Theseus
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@import CoreData;

@protocol CDTimedEvent <NSObject>

@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;

@end
