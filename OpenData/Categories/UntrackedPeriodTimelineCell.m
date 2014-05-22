//
//  UntrackedPeriodTimelineCell.m
//  OpenData
//
//  Created by Michael Walker on 5/22/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "UntrackedPeriodTimelineCell.h"
#import "UITableViewCell+TimelineCell.h"
#import "UntrackedPeriod.h"

@implementation UntrackedPeriodTimelineCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    [self render];

    return self;
}

- (void)render {
    [self applyDefaultStyles];
}

- (void)setupWithTimedEvent:(UntrackedPeriod *)period {
    NSTimeInterval duration = period.duration;
    NSInteger hours = duration / 60 / 60;
    NSInteger minutes = duration/60 - hours*60;
    NSInteger seconds = duration - minutes*60;
    NSString *timeString = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (long)hours, (long)minutes, (long)seconds];

    self.textLabel.text = [NSString stringWithFormat:@"Inactive for %@", timeString];
}
@end
