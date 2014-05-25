//
//  RawMotionActivity.h
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//



@interface _RawMotionActivity : NSManagedObject

@property (nonatomic) NSDate* timestamp;

@property (nonatomic) NSNumber* activity;
@property (nonatomic) NSNumber* confidence;

@end
