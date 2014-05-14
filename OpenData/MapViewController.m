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
#import "FoursquareClient.h"

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

        NSMutableArray *annotations = [NSMutableArray new];
        NSMutableArray *paths = [NSMutableArray new];

        NSMutableArray *currentObjects = [NSMutableArray new];

        for (id obj in array) {
            if ([obj isKindOfClass:RawLocation.class]) {
                [currentObjects addObject:obj];
            } else if ([obj isKindOfClass:RawMotionActivity.class]){
                RawMotionActivity *activity = (RawMotionActivity *)obj;
                if (!(previousActivity.activityType == activity.activityType)) {
                    if (previousActivity.activityType == RawMotionActivityTypeStationary) {
                        Stop *stop = [[Stop alloc] initWithLocations:currentObjects];
                        stop.endTime = activity.timestamp;
                        [annotations addObject:stop];
                    } else {
                        CLLocationCoordinate2D* pointArr = malloc(sizeof(CLLocationCoordinate2D) * currentObjects.count);

                        NSUInteger idx = 0;
                        for (RawLocation *location in currentObjects) {
                            pointArr[idx] = location.coordinate;
                            idx++;
                        }

                        MovementPath *path = [MovementPath polylineWithCoordinates:pointArr count:currentObjects.count];

                        if (activity.activityType == RawMotionActivityTypeWalking) {
                            path.type = MovementTypeWalking;
                        } else if (activity.activityType == RawMotionActivityTypeRunning) {
                            path.type = MovementTypeRunning;
                        } else if (activity.activityType == RawMotionActivityTypeAutomotive) {
                            path.type = MovementTypeTransit;
                        }

                        path.startDate = [(RawLocation *)currentObjects.firstObject timestamp];
                        path.endDate = activity.timestamp;
                        [paths addObject:path];
                    }
                    currentObjects = [NSMutableArray new];
                }

                previousActivity = obj;
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotations:annotations];

            [self.mapView addOverlays:paths];

            [self.mapView setRegion:MKCoordinateRegionMake([annotations.lastObject coordinate], MKCoordinateSpanMake(0.01, 0.01))];
            [[FoursquareClient new] fetchVenuesForCoordinate:[annotations.lastObject coordinate] completion:^(NSArray *results, NSError *error) {
                NSLog(@"================> %@", results);
            }];
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
