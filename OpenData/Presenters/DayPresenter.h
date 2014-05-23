//
//  DayPresenter.h
//  OpenData
//
//  Created by Michael Walker on 5/23/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@class ListViewController;
@protocol TimedEvent;

extern NSString * const DayPresenterDataChangedKey;

@interface DayPresenter : NSObject

@property (nonatomic, readonly) NSUInteger numberOfEvents;
@property (nonatomic, readonly) NSString *dayTitle;
@property (nonatomic, assign) NSUInteger daysAgo;

- (id)initWithDaysAgo:(NSUInteger)daysAgo;

- (id<TimedEvent>)eventForIndex:(NSInteger)index;

@end
