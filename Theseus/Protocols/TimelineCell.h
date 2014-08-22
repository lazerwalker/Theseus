//
//  TimelineCell.h
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/22/14.
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


@class TimedEvent;

@protocol TimelineCellDelegate <NSObject>
- (void)didTapAccessoryViewForTimedEvent:(TimedEvent *)event;
@end

static CGFloat TimelineCellHeightMax = 200.0;
static CGFloat TimelineCellHeightDefault = 44.0;

static NSString * const TimelineLineWidth = @"3.0";
static NSString * const TimelineLineLeftPadding = @"60.0";
static NSString * const TimelineLineRightPadding = @"20.0";


@interface TimelineCell : UITableViewCell

+ (CGFloat)heightForTimedEvent:(TimedEvent *)event;

@property (nonatomic, assign) BOOL isFirstEvent;
@property (nonatomic, weak) id<TimelineCellDelegate> delegate;

- (void)setupWithTimedEvent:(TimedEvent *)event;

@end
