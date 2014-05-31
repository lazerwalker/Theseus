//
//  PathPolyline.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/18/14.
//  Copyright (c) 2014 Mike Lazer-Walker
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>

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
