//
//  MovementPath.m
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "MovementPath.h"

@implementation MovementPath

- (NSTimeInterval)duration {
    return [self.endTime timeIntervalSinceDate:self.startTime];
}

- (NSString *)typeString {
    NSArray *types = @[@"Unknown",
                       @"Walking",
                       @"Running",
                       @"Biking",
                       @"Transit"];
    return types[self.type];
}

@end
