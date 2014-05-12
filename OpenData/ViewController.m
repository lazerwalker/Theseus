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

@import MapKit;
@import CoreMotion;

@interface ViewController ()<MKMapViewDelegate>

@property (strong, nonatomic) LocationManager *locationManager;
@property (strong, nonatomic) MotionManager *motionManager;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

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
    LocationList *list = [LocationList loadFromDisk];

    NSArray *array = [list.locations arrayByAddingObjectsFromArray:list.activities];
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *date1, *date2;

        if ([obj1 isKindOfClass:[CLLocation class]]) {
            date1 = [(CLLocation *)obj1 timestamp];
        } else if ([obj1 isKindOfClass:[CMMotionActivity class]]){
            date1 = [(CMMotionActivity *)obj1 startDate];
        } else {
            NSLog(@"UH OH");
        }

        if ([obj2 isKindOfClass:[CLLocation class]]) {
            date2 = [(CLLocation *)obj2 timestamp];
        } else if ([obj2 isKindOfClass:[CMMotionActivity class]]){
            date2 = [(CMMotionActivity *)obj2 startDate];
        } else {
            NSLog(@"UH OH");
        }

        return [date1 compare:date2];
    }];

    CMMotionActivity *previousActivity;

    NSMutableArray *annotations = [NSMutableArray new];
    NSMutableArray *movementPoints = [NSMutableArray new];
    for (id obj in array) {
        if ([obj isKindOfClass:[CLLocation class]]) {
            if (previousActivity.stationary) {
                [annotations addObject:obj];
            } else {
                [movementPoints addObject:obj];
            }
        } else {
            previousActivity = obj;
        }
    }

    NSLog(@"================> %@", annotations);
    [self.mapView addAnnotations:annotations];

    CLLocationCoordinate2D* pointArr = malloc(sizeof(CLLocationCoordinate2D) * movementPoints.count);

    NSUInteger idx = 0;
    for (CLLocation *location in movementPoints) {
        pointArr[idx] = location.coordinate;
        idx++;
    }

    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:pointArr count:movementPoints.count];
    [self.mapView addOverlay:polyline];

    [self.mapView setRegion:MKCoordinateRegionMake([annotations.lastObject coordinate], MKCoordinateSpanMake(0.01, 0.01))];
}

#pragma mark - MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor redColor];
    polylineView.lineWidth = 3.0;

    return polylineView;
}
@end
