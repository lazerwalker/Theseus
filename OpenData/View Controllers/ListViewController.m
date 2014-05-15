//
//  ListViewController.m
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "ListViewController.h"
#import "DataProcessor.h"
#import "MovementPath.h"
#import "Stop.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface ListViewController ()
@property (strong, nonatomic) NSArray *data;
@end

@implementation ListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (!self) return nil;

    self.title = @"List";

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

#pragma mark - 
- (void)loadData {
    DataProcessor *dataProcessor = [DataProcessor new];
    [dataProcessor processDataWithCompletion:^(NSArray *stops, NSArray *paths) {
        NSArray *data = [stops arrayByAddingObjectsFromArray:paths];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
        self.data = [data sortedArrayUsingDescriptors:@[descriptor]];

        [self.tableView reloadData];
    }];
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterShortStyle;
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    });

    return _dateFormatter;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = self.data[indexPath.row];

    if ([object isKindOfClass:Stop.class]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%f, %f", [(Stop *)object coordinate].latitude, [(Stop *)object coordinate].longitude];
    } else {
        cell.textLabel.text = [(MovementPath *)object typeString];
    }

    NSTimeInterval duration = [(Stop *)object duration];
    NSInteger hours = duration / 60 / 60;
    NSInteger minutes = duration/60 - hours*60;
    NSInteger seconds = duration - minutes*60;
    NSString *timeString = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (long)hours, (long)minutes, (long)seconds];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ — %@ (%@)", [self.dateFormatter stringFromDate:[(Stop *)object startTime]], [self.dateFormatter stringFromDate:[(Stop *)object endTime]], timeString];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    return cell;
}


@end
