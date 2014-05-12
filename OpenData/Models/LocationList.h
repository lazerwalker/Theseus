//
//  LocationList.h
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Mantle.h>

@interface LocationList : MTLModel

@property (strong, nonatomic) NSArray *locations;
@property (strong, nonatomic) NSArray *activities;

+ (instancetype)loadFromDisk;

- (void)addLocations:(NSArray *)locations;
- (void)addActivities:(NSArray *)activities;

@end
