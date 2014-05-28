//
//  TimelineCell.h
//  OpenData
//
//  Created by Michael Walker on 5/22/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

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
@property (nonatomic, assign) BOOL isNow;
@property (nonatomic, weak) id<TimelineCellDelegate> delegate;

- (void)setupWithTimedEvent:(TimedEvent *)event;

@end
