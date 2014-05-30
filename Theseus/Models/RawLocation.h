//
//  RawLocation.h
//  Theseus
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "RawDataPoint.h"
@import MapKit;

@interface RawLocation : RawDataPoint

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) CLLocationDegrees latitude, longitude;
@property (nonatomic) CLLocationDistance altitude;
@property (nonatomic) CLLocationSpeed speed;
@property (nonatomic) CLLocationAccuracy horizontalAccuracy,  verticalAccuracy;

- (void)setupWithLocation:(CLLocation *)location;
- (CLLocationDistance)distanceFromLocation:(RawLocation *)location;

@end
