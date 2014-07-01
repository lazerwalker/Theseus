//
//  DayPresenter.h
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/23/14.
//  Copyright (c) 2014 Mike Lazer-Walker
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>

#import <Mantle.h>

@class ListViewController;
@class TimedEvent;
@import MapKit;

extern NSString * const DayDataChangedKey;
extern NSString * const DayStepsChangedKey;

extern NSString * const TheseusDidProcessNewDataLocation;
extern NSString * const TheseusDidProcessNewDataStep;

@interface Day : MTLModel<MTLJSONSerializing>

@property (nonatomic, readonly) NSUInteger numberOfEvents;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSInteger steps;
@property (nonatomic, readonly) NSArray *stops;
@property (nonatomic, readonly) NSArray *paths;
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) MKCoordinateRegion region;
@property (nonatomic, assign) NSUInteger daysAgo;

- (id)initWithDaysAgo:(NSUInteger)daysAgo;

- (TimedEvent *)eventForIndex:(NSInteger)index;
- (NSString *)jsonRepresentation;

@end
