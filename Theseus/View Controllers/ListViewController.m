//
//  ListViewController.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/13/14.
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

#import "ListViewController.h"
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
#import "MapViewController.h"

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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSettingsButton)];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Timeline"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:nil
                                                                action:nil];
    self.navigationItem.backBarButtonItem = backItem;


    [self.tableView registerClass:[StopTimelineCell class] forCellReuseIdentifier:[StopTimelineCell classReuseIdentifier]];
    [self.tableView registerClass:[PathTimelineCell class] forCellReuseIdentifier:[PathTimelineCell classReuseIdentifier]];
    [self.tableView registerClass:[UntrackedPeriodTimelineCell class] forCellReuseIdentifier:[UntrackedPeriodTimelineCell classReuseIdentifier]];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];
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
    cell.isNow = NO;
    cell.isFirstEvent = NO;

    if (indexPath.row == 0) {
        cell.isFirstEvent = YES;
    }

    if (indexPath.row == ([self.tableView numberOfRowsInSection:0] - 1) && self.daysAgo == 0) {
        cell.isNow = YES;
    }

    TimedEvent *obj = [self.day eventForIndex:indexPath.row];
    [cell setupWithTimedEvent:obj];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    MapViewController *mapController = [[MapViewController alloc] initWithDay:self.day];

    TimedEvent *obj = [self.day eventForIndex:indexPath.row];
    if ([obj isKindOfClass:Stop.class]) {
        [mapController selectAnnotationForStop:(Stop *)obj];
    }

    [self.navigationController pushViewController:mapController animated:YES];
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
            stop.venueConfirmed = YES;

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
