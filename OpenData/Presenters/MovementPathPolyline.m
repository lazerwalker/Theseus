//
//  MovementPathPolyline.m
//  OpenData
//
//  Created by Michael Walker on 5/18/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "MovementPathPolyline.h"
#import "RawLocation.h"

@implementation MovementPathPolyline

+ (id)polylineWithMovementPath:(Path *)path {
    CLLocationCoordinate2D* pointArr = malloc(sizeof(CLLocationCoordinate2D) * path.locations.count);

    NSUInteger idx = 0;
    for (RawLocation *location in path.locations) {
        pointArr[idx] = location.coordinate;
        idx++;
    }

    MovementPathPolyline *polyline = [MovementPathPolyline polylineWithCoordinates:pointArr count:path.locations.count];
    polyline.type = path.type;
    return path;
}

@end
