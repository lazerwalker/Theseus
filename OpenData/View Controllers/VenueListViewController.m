//
//  VenueListViewController.m
//  OpenData
//
//  Created by Michael Walker on 5/19/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "VenueListViewController.h"

#import "Stop.h"
#import "FoursquareClient.h"
#import "FoursquareVenue.h"
#import "Venue.h"

#import <UIImageView+WebCache.h>

static NSString * const CellIdentifier = @"cell";

static CGFloat NearbyLocalResultsRadius = 0.01;

typedef NS_ENUM(NSUInteger, TableSections) {
    TableSectionNewResult,
    TableSectionLocalResults,
    TableSectionRemoteResults,
    NumberOfTableSections
};

@interface VenueListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) FoursquareClient *client;

@property (nonatomic, strong) NSArray *localResults;
@property (nonatomic, strong) NSArray *results;

@end

@implementation VenueListViewController

- (id)initWithStop:(Stop *)stop {
    self = [super init];
    if (!self) return nil;

    self.stop = stop;
    self.title = @"Select A Venue";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTapCancelButton)];

    self.results = [NSArray new];
    self.localResults = [NSArray new];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchLocalNearbyResults];
    [self fetchRemoteNearbyResults];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    self.searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)didTapCancelButton {
    if (self.didTapCancelButtonBlock) {
        self.didTapCancelButtonBlock();
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NumberOfTableSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == TableSectionNewResult) {
        return (self.searchBar.text.length > 0 ? 1 : 0);
    } else if (section == TableSectionLocalResults) {
        return self.localResults.count;
    } else if (section == TableSectionRemoteResults) {
        return self.results.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

    Venue *venue;
    if (indexPath.section == TableSectionNewResult) {
        venue = [Venue MR_createEntity];
        venue.coordinate = self.stop.coordinate;
        venue.name = self.searchBar.text;
    } else if (indexPath.section == TableSectionLocalResults) {
        venue = self.localResults[indexPath.row];
    } else if (indexPath.section == TableSectionRemoteResults) {
        FoursquareVenue *foursquareVenue = self.results[indexPath.row];
        venue = [Venue MR_findFirstByAttribute:@"foursquareId" withValue:foursquareVenue.foursquareId];
        if (!venue) {
            venue = [Venue MR_createEntity];
            [venue setupWithFoursquareVenue:foursquareVenue];
        }
    }

    if (self.didSelectVenueBlock) {
        self.didSelectVenueBlock(venue);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == TableSectionLocalResults && self.localResults.count > 0) {
        return @"Places You've Been Near Here";
    } else if (section == TableSectionRemoteResults) {
        return @"Nearby Foursquare Venues";
    }

    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TableSectionNewResult) {
        cell.textLabel.text = [NSString stringWithFormat:@"Use '%@'", self.searchBar.text];
        cell.imageView.image = nil;
    } else if (indexPath.section == TableSectionLocalResults) {
        Venue *venue = self.localResults[indexPath.row];
        cell.textLabel.text = venue.name;
        if (venue.iconURL) {
            [cell.imageView setImageWithURL:venue.iconURL];
        } else {
            cell.imageView.image = nil;
        }
    } else if (indexPath.section == TableSectionRemoteResults) {
        FoursquareVenue *venue = self.results[indexPath.row];

        cell.textLabel.text = venue.name;
        [cell.imageView setImageWithURL:venue.iconURL];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchLocally:searchBar.text];
    [self searchRemotely:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableSectionNewResult] withRowAnimation:UITableViewRowAnimationNone];

    if (searchText.length == 0) {
        [self fetchLocalNearbyResults];
    } else {
        [self searchLocally:searchBar.text];
        [self searchRemotely:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self fetchLocalNearbyResults];
    [self fetchRemoteNearbyResults];
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
}

#pragma mark - Private
- (void)fetchLocalNearbyResults {
    NSPredicate *nearby = [NSPredicate predicateWithFormat:@"(latitude > %@) AND (latitude < %@) AND (longitude > %@) AND (longitude < %@)", @(self.stop.coordinate.latitude - NearbyLocalResultsRadius), @(self.stop.coordinate.latitude + NearbyLocalResultsRadius), @(self.stop.coordinate.longitude - NearbyLocalResultsRadius), @(self.stop.coordinate.longitude + NearbyLocalResultsRadius)];
    NSArray *results = [Venue MR_findAllWithPredicate:nearby];
    self.localResults = [results sortedArrayUsingComparator:^NSComparisonResult(Venue *obj1, Venue *obj2) {
        NSNumber *distance1 = @([self.stop distanceFromCoordinate:obj1.coordinate]);
        NSNumber *distance2 = @([self.stop distanceFromCoordinate:obj2.coordinate]);
        return [distance1 compare:distance2];
    }];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableSectionLocalResults] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)fetchRemoteNearbyResults {
    self.client = [FoursquareClient new];
    [self.client fetchVenuesNearCoordinate:self.stop.coordinate completion:^(NSArray *results, NSError *error) {
        NSArray *localFoursquareIds = [self.localResults valueForKey:@"foursquareId"];
        NSPredicate *blacklist = [NSPredicate predicateWithFormat:@"NOT (foursquareId IN %@)", localFoursquareIds];
        self.results = [results filteredArrayUsingPredicate:blacklist];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableSectionRemoteResults] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)searchLocally:(NSString *)query {
    NSPredicate *nearby = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", query];
    self.localResults = [Venue MR_findAllWithPredicate:nearby];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableSectionLocalResults] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)searchRemotely:(NSString *)query {
    [self.client searchFor:query nearCoordinate:self.stop.coordinate completion:^(NSArray *results, NSError *error) {
        NSArray *localFoursquareIds = [self.localResults valueForKey:@"foursquareId"];
        NSPredicate *blacklist = [NSPredicate predicateWithFormat:@"NOT (foursquareId IN %@)", localFoursquareIds];
        self.results = [results filteredArrayUsingPredicate:blacklist];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableSectionRemoteResults] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

@end
