//
//  LocationList.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "LocationList.h"

@implementation LocationList

+ (instancetype)loadFromDisk {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:self.filepath] ?: [self new];
}

+ (NSString *)filepath {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    return [path stringByAppendingPathComponent:NSStringFromClass(self.class)];
}

- (void)addLocations:(NSArray *)locations {
    if (!self.locations) self.locations = [NSArray new];
    self.locations = [self.locations arrayByAddingObjectsFromArray:locations];
    [self persistToDisk];
}

- (void)addActivities:(NSArray *)activities {
    if (!self.activities) self.activities = [NSArray new];
    self.activities = [self.activities arrayByAddingObjectsFromArray:activities];
    [self persistToDisk];
}

- (void)persistToDisk {
    [NSKeyedArchiver archiveRootObject:self toFile:self.class.filepath];
}
@end
