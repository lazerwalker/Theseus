//
//  UntrackedPeriodTimelineCell.h
//  Theseus
//
//  Created by Michael Walker on 5/22/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "TimelineCell.h"

@interface UntrackedPeriodTimelineCell : TimelineCell

@property (nonatomic, assign) BOOL isFirstEvent;
@property (nonatomic, assign) BOOL isNow;

@end
