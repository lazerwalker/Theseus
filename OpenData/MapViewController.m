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
#import "RawLocation.h"
#import "RawMotionActivity.h"

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
    self.title = @"Map";

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self render];
}

- (void)render {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[RawLocation MR_findAllSortedBy:@"timestamp" ascending:YES]
                          arrayByAddingObjectsFromArray:
                          [RawMotionActivity MR_findAllSortedBy:@"timestamp" ascending:YES]];

        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
        array = [array sortedArrayUsingDescriptors:@[descriptor]];

        RawMotionActivity *previousActivity;

        NSMutableArray *locations = [NSMutableArray new];
        NSMutableArray *movementPoints = [NSMutableArray new];
        NSMutableArray *paths = [NSMutableArray new];
        for (id obj in array) {
            if ([obj isKindOfClass:[RawLocation class]]) {
                if (!previousActivity || previousActivity.activityType == RawMotionActivityTypeStationary) {
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

                if (previousActivity.activityType == RawMotionActivityTypeWalking) {
                    path.type = MovementTypeWalking;
                } else if (previousActivity.activityType == RawMotionActivityTypeRunning) {
                    path.type = MovementTypeRunning;
                } else if (previousActivity.activityType == RawMotionActivityTypeAutomotive) {
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
