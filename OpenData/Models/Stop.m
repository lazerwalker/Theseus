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

    CLLocationDegrees latitude = [[locations valueForKeyPath:@"@avg.latitude"] doubleValue];
    CLLocationDegrees longitude = [[locations valueForKeyPath:@"@avg.longitude"] doubleValue];
    self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);

    return self;
}

@end
