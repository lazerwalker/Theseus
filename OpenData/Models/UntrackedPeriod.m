//
//  UntrackedPeriod.m
//  OpenData
//
//  Created by Michael Walker on 5/21/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "UntrackedPeriod.h"


@implementation UntrackedPeriod

@dynamic startTime;
@dynamic endTime;

- (NSTimeInterval)duration {
    return [self.endTime timeIntervalSinceDate:self.startTime];
}

@end
