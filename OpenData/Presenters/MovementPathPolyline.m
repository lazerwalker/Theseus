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

+ (id)polylineWithMovementPath:(MovementPath *)movementPath {
    CLLocationCoordinate2D* pointArr = malloc(sizeof(CLLocationCoordinate2D) * movementPath.locations.count);

    NSUInteger idx = 0;
    for (RawLocation *location in movementPath.locations) {
        pointArr[idx] = location.coordinate;
        idx++;
    }

    MovementPathPolyline *path = [MovementPathPolyline polylineWithCoordinates:pointArr count:movementPath.locations.count];
    path.type = movementPath.type;
    return path;
}

@end
