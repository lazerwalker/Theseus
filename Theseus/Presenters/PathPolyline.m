//
//  MovementPathPolyline.m
//  Theseus
//
//  Created by Michael Walker on 5/18/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "PathPolyline.h"
#import "RawLocation.h"

@implementation PathPolyline

+ (id)polylineWithPath:(Path *)path {
    CLLocationCoordinate2D* pointArr = malloc(sizeof(CLLocationCoordinate2D) * path.locations.count);

    NSUInteger idx = 0;
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    NSArray *locations = [path.locations sortedArrayUsingDescriptors:@[descriptor]];
    for (RawLocation *location in locations) {
        pointArr[idx] = location.coordinate;
        idx++;
    }

    PathPolyline *polyline = [PathPolyline polylineWithCoordinates:pointArr count:path.locations.count];
    polyline.type = path.type;
    return polyline;
}

@end
