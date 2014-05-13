//
//  Location.h
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Mantle.h>
@import MapKit;

@interface Stop : MTLModel<MKAnnotation>

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic) CLLocationDistance altitude;
@property (assign, nonatomic) CLLocationAccuracy horizontalAccuracy;
@property (assign, nonatomic) CLLocationAccuracy verticalAccuracy;

- (id)initWithLocations:(NSArray *)locations;

@end
