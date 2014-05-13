//
//  MovementPath.h
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@import MapKit;

typedef NS_ENUM(NSUInteger, MovementType) {
    MovementTypeUnknown,
    MovementTypeWalking,
    MovementTypeRunning,
    MovementTypeBiking,
    MovementTypeTransit
};

@interface MovementPath : MKPolyline

@property (nonatomic, assign) MovementType type;

@end
