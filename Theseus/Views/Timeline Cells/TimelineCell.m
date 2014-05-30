//
//  TimelineCell.m
//  Theseus
//
//  Created by Michael Walker on 5/28/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "TimelineCell.h"

@implementation TimelineCell

+ (CGFloat)heightForTimedEvent:(TimedEvent *)event {
    return TimelineCellHeightDefault;
}

- (void)setupWithTimedEvent:(TimedEvent *)event {
    
}
@end