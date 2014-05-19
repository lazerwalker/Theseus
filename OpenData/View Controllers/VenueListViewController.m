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

#import <UIImageView+WebCache.h>

static NSString * const CellIdentifier = @"cell";

@interface VenueListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FoursquareClient *client;
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

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.client = [FoursquareClient new];
    [self.client fetchVenuesForCoordinate:self.stop.coordinate completion:^(NSArray *results, NSError *error) {
        self.results = results;
        [self.tableView reloadData];
    }];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didTapCancelButton {
    if (self.didTapCancelButtonBlock) {
        self.didTapCancelButtonBlock();
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
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

    FoursquareVenue *venue = self.results[indexPath.row];
    if (self.didSelectVenueBlock) {
        self.didSelectVenueBlock(venue);
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    FoursquareVenue *venue = self.results[indexPath.row];

    cell.textLabel.text = venue.name;
    [cell.imageView setImageWithURL:venue.iconURL];
}

@end
