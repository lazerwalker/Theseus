//
//  DayPresenter.h
//  OpenData
//
//  Created by Michael Walker on 5/23/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Mantle.h>

@class ListViewController;
@class TimedEvent;

extern NSString * const DayDataChangedKey;

@interface Day : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSUInteger numberOfEvents;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, assign) NSUInteger daysAgo;

- (id)initWithDaysAgo:(NSUInteger)daysAgo;

- (TimedEvent *)eventForIndex:(NSInteger)index;

- (NSString *)jsonRepresentation;

@end
