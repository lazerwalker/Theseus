//
//  UITableViewCell+TimelineCell.h
//  OpenData
//
//  Created by Michael Walker on 5/22/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat TimelineCellHeightMax = 200.0;
static CGFloat TimelineCellHeightDefault = 44.0;

static NSString * const TimelineLineWidth = @"3.0";
static NSString * const TimelineLineLeftPadding = @"40.0";

@interface UITableViewCell (TimelineCell)

- (void)applyDefaultStyles;

@end
