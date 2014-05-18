//
//  ViewController.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "MapViewController.h"
#import "MovementPath.h"
#import "Stop.h"
#import "DataProcessor.h"

@import MapKit;
@import CoreMotion;

@interface MapViewController ()<MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;

@end

@implementation MapViewController

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    self.view = self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.title = @"Map";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Process" style:UIBarButtonItemStylePlain target:self action:@selector(render)];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)render {
    DataProcessor *dataProcessor = [DataProcessor new];
    [dataProcessor processDataWithCompletion:^(NSArray *stops, NSArray *paths) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotations:stops];
//            [self.mapView addOverlays:paths];

            [self.mapView setRegion:MKCoordinateRegionMake([stops.lastObject coordinate], MKCoordinateSpanMake(0.01, 0.01))];
        });
    }];
}

#pragma mark - MKMapViewDelegate
// TODO: MovementPathOverlay object that implements MKPolyline and wraps a MovementPath object
/*- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(MovementPath *)overlay {
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
}*/
@end
