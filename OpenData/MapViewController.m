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
#import "PathPolyline.h"
#import "StopAnnotation.h"

#import <Asterism.h>

@import MapKit;

@interface MapViewController ()<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSOrderedSet *annotations;
@property (nonatomic, strong) NSOrderedSet *stops;

@end

@implementation MapViewController

- (instancetype)initWithDay:(Day *)day {
    self = [super init];
    if (!self) return nil;

    self.day = day;

    self.view = self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;

    NSArray *annotations = ASTMap(self.day.stops, ^id(Stop *stop) {
        return [[StopAnnotation alloc] initWithStop:stop];
    });
    [self.mapView addAnnotations:annotations];
    self.annotations = [NSOrderedSet orderedSetWithArray:annotations];
    self.stops = [NSOrderedSet orderedSetWithArray:self.day.stops];

    NSArray *paths = ASTMap(self.day.paths, ^id(Path *path) {
        return [PathPolyline polylineWithPath:path];
    });
    [self.mapView addOverlays:paths];
    
    [self.mapView setRegion:day.region];

    self.title = day.title;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)selectAnnotationForStop:(Stop *)stop {
    NSUInteger index = [self.stops indexOfObject:stop];
    if (self.annotations[index]) {
        StopAnnotation *annotation = self.annotations[index];
        [self.mapView selectAnnotation:annotation animated:YES];
    }
}

#pragma mark - MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(PathPolyline *)overlay {
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
