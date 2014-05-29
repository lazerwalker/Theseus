//
//  ListViewController.m
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "ListViewController.h"
#import "DataProcessor.h"
#import "Stop.h"

#import "TimedEvent.h"
#import "TimelineCell.h"

#import "StopTimelineCell.h"
#import "PathTimelineCell.h"
#import "UntrackedPeriodTimelineCell.h"

#import "Day.h"

#import "FoursquareVenue.h"
#import "Venue.h"
#import "VenueListViewController.h"
#import "SettingsViewController.h"

@interface ListViewController ()
@property (strong, nonatomic) NSArray *data;
@property (nonatomic, strong) Day *day;
@end

@implementation ListViewController

- (id)initWithDaysAgo:(NSInteger)daysAgo {
    Day *day = [[Day alloc] initWithDaysAgo:daysAgo];
    return [self initWithDay:day];
}

- (id)initWithDay:(Day *)day {
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) return nil;

    self.day = day;
    [self.day addObserver:self forKeyPath:DayDataChangedKey options:0 context:nil];

    self.title = self.day.title;

    return self;
}

- (void)dealloc {
    [self.day removeObserver:self forKeyPath:DayDataChangedKey];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, self.tabBarController.tabBar.bounds.size.height, 0);

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Process" style:UIBarButtonItemStylePlain target:self action:@selector(reprocess)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSettingsButton)];

    [self.tableView registerClass:[StopTimelineCell class] forCellReuseIdentifier:[StopTimelineCell classReuseIdentifier]];
    [self.tableView registerClass:[PathTimelineCell class] forCellReuseIdentifier:[PathTimelineCell classReuseIdentifier]];
    [self.tableView registerClass:[UntrackedPeriodTimelineCell class] forCellReuseIdentifier:[UntrackedPeriodTimelineCell classReuseIdentifier]];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {
    if ([keyPath isEqualToString:DayDataChangedKey]) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - 
- (NSInteger)daysAgo {
    return self.day.daysAgo;
}

#pragma mark -
- (void)reprocess {
    DataProcessor *dataProcessor = [DataProcessor new];
    [dataProcessor reprocessData];
}

- (void)didTapSettingsButton {
    SettingsViewController *settingsController = [SettingsViewController new];
    [self.navigationController pushViewController:settingsController animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimedEvent *obj = [self.day eventForIndex:indexPath.row];
    Class cellClass = [self timelineCellClassForObject:obj];
    return [cellClass heightForTimedEvent:obj];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(TimelineCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        cell.isFirstEvent = YES;
    }

    if (indexPath.row == ([self.tableView numberOfRowsInSection:0] - 1) && self.daysAgo == 0) {
        cell.isNow = YES;
    }

    TimedEvent *obj = [self.day eventForIndex:indexPath.row];
    [cell setupWithTimedEvent:obj];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.day.numberOfEvents;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimedEvent *obj = [self.day eventForIndex:indexPath.row];
    NSString *cellIdentifier = [[self timelineCellClassForObject:obj] classReuseIdentifier];

    TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;

    return cell;
}

#pragma mark - TimelineCellDelegate
- (void)didTapAccessoryViewForTimedEvent:(TimedEvent *)event {
    if (![event isKindOfClass:Stop.class]) return;
    Stop *stop = (Stop *)event;

    VenueListViewController *venueList = [[VenueListViewController alloc] initWithStop:stop];

    venueList.didTapCancelButtonBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };

    venueList.didSelectVenueBlock = ^(Venue *venue) {
        [self dismissViewControllerAnimated:YES completion:nil];

        [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
            Venue *oldVenue = stop.venue;
            if (oldVenue && oldVenue.stops.count == 1) {
                [oldVenue destroy];
            }

            stop.venue = venue;
            stop.venueConfirmed = @(YES);

            [self.tableView reloadData];
        } completion:nil];
    };

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:venueList];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Private
- (Class)timelineCellClassForObject:(TimedEvent *)obj {
    NSString *className = [NSString stringWithFormat:@"%@TimelineCell", NSStringFromClass(obj.class)];
    return NSClassFromString(className);
}

@end
