//
//  Location.m
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "Stop.h"

@implementation Stop

- (id)initWithLocations:(NSArray *)locations {
    self = [super init];
    if (!self) return nil;

    self.startTime = [locations valueForKeyPath:@"@min.timestamp"];
    self.endTime = [locations valueForKeyPath:@"@max.timestamp"];

    self.altitude = [[locations valueForKeyPath:@"@avg.altitude"] doubleValue];
    self.horizontalAccuracy = [[locations valueForKeyPath:@"@avg.horizontalAccuracy"] doubleValue];
    self.verticalAccuracy = [[locations valueForKeyPath:@"@avg.verticalAccuracy"] doubleValue];

    CLLocationDegrees latitude, longitude;
    for (CLLocation *location in locations) {
        latitude += location.coordinate.latitude;
        longitude += location.coordinate.longitude;
    }

    self.coordinate = CLLocationCoordinate2DMake(latitude/locations.count, longitude/locations.count);

    return self;
}

@end
