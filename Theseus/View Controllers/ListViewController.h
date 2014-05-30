//
//  ListViewController.h
//  Theseus
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "TimelineCell.h"

@class Day;

@interface ListViewController : UITableViewController<TimelineCellDelegate>

@property (nonatomic, readonly) NSInteger daysAgo;

- (id)initWithDaysAgo:(NSInteger)daysAgo;
- (id)initWithDay:(Day *)day;

@end
