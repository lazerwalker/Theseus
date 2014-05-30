//
//  ViewController.m
//  Theseus
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
#import "VenueListViewController.h"
#import "Venue.h"

#import <FAKFontAwesome.h>
#import <Asterism.h>

@import MapKit;

static NSString * const AnnotationIdentifier = @"AnnotationIdentifier";

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
    self.mapView.showsPointsOfInterest = NO;

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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeSystem];
        editButton.frame = CGRectMake(0, 0, 44.0, 44.0);

        FAKFontAwesome *pencil = [FAKFontAwesome pencilIconWithSize:18.0];
        UIImage *editIcon = [pencil imageWithSize:CGSizeMake(44.0, 44.0)];
        editButton.tintColor = [UIColor lightGrayColor];
        [editButton setImage:editIcon forState:UIControlStateNormal];

        annotationView.rightCalloutAccessoryView = editButton;
        annotationView.canShowCallout = YES;
    }

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    Stop *stop = [(StopAnnotation *)view.annotation stop];

    VenueListViewController *venueList = [[VenueListViewController alloc] initWithStop:stop];

    venueList.didTapCancelButtonBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };

    venueList.didSelectVenueBlock = ^(Venue *venue) {
        [self dismissViewControllerAnimated:YES completion:nil];

        [MagicalRecord saveUsingCurrentThreadContextWithBlock:^(NSManagedObjectContext *localContext) {
            Venue *oldVenue = stop.venue;
            if (oldVenue && oldVenue.stops.count == 1) {
                [oldVenue destroy];
            }

            stop.venue = venue;
            stop.venueConfirmed = YES;

            [self.mapView deselectAnnotation:view.annotation animated:NO];
            [self.mapView selectAnnotation:view.annotation animated:NO];
        } completion:nil];
    };

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:venueList];
    [self presentViewController:navController animated:YES completion:nil];
}
@end
