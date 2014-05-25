//
//  _RawLocation.h
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//


@interface _RawLocation : NSManagedObject

@property (nonatomic) NSDate *timestamp;

@property (nonatomic) NSNumber *altitude;
@property (nonatomic) NSNumber *speed;
@property (nonatomic) NSNumber *horizontalAccuracy;
@property (nonatomic) NSNumber *verticalAccuracy;

@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;

@end
