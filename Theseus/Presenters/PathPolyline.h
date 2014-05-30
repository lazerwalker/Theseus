//
//  MovementPathPolyline.h
//  Theseus
//
//  Created by Michael Walker on 5/18/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@import MapKit;
#import "Path.h"

@interface PathPolyline : MKPolyline

@property (nonatomic, assign) MovementType type;

+ (id)polylineWithPath:(Path *)path;

@end
