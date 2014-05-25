//
//  MovementPathPolyline.h
//  OpenData
//
//  Created by Michael Walker on 5/18/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@import MapKit;
#import "Path.h"

@interface MovementPathPolyline : MKPolyline

@property (nonatomic, assign) MovementType type;

+ (id)polylineWithMovementPath:(Path *)movementPath;

@end
