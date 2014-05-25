//
//  RawDataPoint.h
//  OpenData
//
//  Created by Michael Walker on 5/25/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@interface RawDataPoint : NSObject

+ (Class)modelClass;

@property (nonatomic) NSDate *timestamp;
@property (nonatomic) NSManagedObject *model;

@end
