//
//  ListViewController.h
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@class Day;

@interface ListViewController : UITableViewController

@property (nonatomic, readonly) NSInteger daysAgo;

- (id)initWithDaysAgo:(NSInteger)daysAgo;
- (id)initWithDay:(Day *)day;

@end
