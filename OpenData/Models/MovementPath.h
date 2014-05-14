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
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;

@property (readonly) NSTimeInterval duration;
@property (readonly) NSString *typeString;

@end
