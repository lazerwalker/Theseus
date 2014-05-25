//
//  StopTimelineCell.h
//  OpenData
//
//  Created by Michael Walker on 5/22/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@class TimedEvent;

@interface StopTimelineCell : UITableViewCell

@property (nonatomic, assign) BOOL isFirstEvent;
@property (nonatomic, assign) BOOL isNow;

- (void)setupWithTimedEvent:(TimedEvent *)event;

@end
