//
//  ViewController.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "MapViewController.h"
#import "Path.h"
#import "Stop.h"
#import "DataProcessor.h"
#import "Day.h"
#import "MovementPathPolyline.h"

@import MapKit;

@interface MapViewController ()<MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;

@end

@implementation MapViewController

- (instancetype)initWithDay:(Day *)day {
    self = [super init];
    if (!self) return nil;

    self.day = day;

    self.view = self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.title = day.title;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(MovementPathPolyline *)overlay {
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
