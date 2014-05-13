//
//  ViewController.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "ViewController.h"
#import "LocationManager.h"
#import "MotionManager.h"
#import "LocationList.h"
#import "MovementPath.h"
#import "Stop.h"
#import "RawLocation.h"

@import MapKit;
@import CoreMotion;

@interface ViewController ()<MKMapViewDelegate>

@property (strong, nonatomic) LocationManager *locationManager;
@property (strong, nonatomic) MotionManager *motionManager;

@property (strong, nonatomic) MKMapView *mapView;

@end

@implementation ViewController

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.view = self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self startMonitoring];
    [self render];
}

- (void)startMonitoring {
    self.locationManager = [LocationManager new];
    [self.locationManager startMonitoring];

    self.motionManager = [MotionManager new];
    [self.motionManager startMonitoring];
}

- (void)render {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LocationList *list = [LocationList loadFromDisk];
        NSArray *array = [[RawLocation MR_findAllSortedBy:@"timestamp" ascending:YES] arrayByAddingObjectsFromArray:list.activities];
        array = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDate *date1, *date2;

            if ([obj1 isKindOfClass:[RawLocation class]]) {
                date1 = [(RawLocation *)obj1 timestamp];
            } else if ([obj1 isKindOfClass:[CMMotionActivity class]]){
                date1 = [(CMMotionActivity *)obj1 startDate];
            } else {
                @throw @"Expected a CLLocation or CMMotionActivity object";
            }

            if ([obj2 isKindOfClass:[RawLocation class]]) {
                date2 = [(RawLocation *)obj2 timestamp];
            } else if ([obj2 isKindOfClass:[CMMotionActivity class]]){
                date2 = [(CMMotionActivity *)obj2 startDate];
            } else {
                @throw @"Expected a CLLocation or CMMotionActivity object";
            }

            return [date1 compare:date2];
        }];

        CMMotionActivity *previousActivity;

        NSMutableArray *locations = [NSMutableArray new];
        NSMutableArray *movementPoints = [NSMutableArray new];
        NSMutableArray *paths = [NSMutableArray new];
        for (id obj in array) {
            if ([obj isKindOfClass:[RawLocation class]]) {
                if (previousActivity.stationary) {
                    [locations addObject:obj];
                } else {
                    [movementPoints addObject:obj];
                }
            } else {
                previousActivity = obj;

                CLLocationCoordinate2D* pointArr = malloc(sizeof(CLLocationCoordinate2D) * movementPoints.count);

                NSUInteger idx = 0;
                for (RawLocation *location in movementPoints) {
                    pointArr[idx] = location.coordinate;
                    idx++;
                }

                MovementPath *path = [MovementPath polylineWithCoordinates:pointArr count:movementPoints.count];

                if (previousActivity.walking) {
                    path.type = MovementTypeWalking;
                } else if (previousActivity.running) {
                    path.type = MovementTypeRunning;
                } else if (previousActivity.automotive) {
                    path.type = MovementTypeTransit;
                } else {
                    CLLocationSpeed speed = [[movementPoints valueForKeyPath:@"@avg.speed"] doubleValue];
                    if (speed > 1.0) {
                        path.type = MovementTypeBiking;
                    }
                }

                [paths addObject:path];
                [movementPoints removeAllObjects];
            }
        }

        NSMutableArray *annotations = [NSMutableArray new];
        for (RawLocation *location in locations) {
            Stop *stop = [[Stop alloc] initWithLocations:@[location]];
            [annotations addObject:stop];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotations:annotations];

            [self.mapView addOverlays:paths];

            [self.mapView setRegion:MKCoordinateRegionMake([annotations.lastObject coordinate], MKCoordinateSpanMake(0.01, 0.01))];
        });
    });
}

#pragma mark - MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(MovementPath *)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];


    if (overlay.type == MovementTypeWalking) {
        polylineView.strokeColor = [UIColor redColor];
    } else if (overlay.type == MovementTypeRunning) {
        polylineView.strokeColor = [UIColor blueColor];
    } else if (overlay.type == MovementTypeBiking) {
        polylineView.strokeColor = [UIColor greenColor];
    } else if (overlay.type == MovementTypeRunning) {
        polylineView.strokeColor = [UIColor yellowColor];
    } else {
        polylineView.strokeColor = [UIColor blackColor];
    }

    polylineView.lineWidth = 10.0;

    return polylineView;
}
@end
