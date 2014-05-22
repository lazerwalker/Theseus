//
//  TimedEvent.h
//  OpenData
//
//  Created by Michael Walker on 5/22/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TimedEvent <NSObject>

@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;

@property (nonatomic, readonly) NSTimeInterval duration;

@end
