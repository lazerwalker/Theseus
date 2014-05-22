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

@interface UntrackedPeriodTimelineCell ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *descriptionLabel;
@end

@implementation UntrackedPeriodTimelineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    [self render];

    return self;
}

- (void)render {
    [self applyDefaultStyles];

    self.line = [UIView new];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.line];

    self.descriptionLabel = [UILabel new];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.descriptionLabel];

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];

    NSDictionary *views = @{@"line": self.line,
                            @"descriptionLabel": self.descriptionLabel};

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"|-(==leftPadding)-[line(lineWidth)]-[descriptionLabel]-|"
                                       options:NSLayoutFormatAlignAllCenterY
                                       metrics:@{@"lineWidth": @"3.0",
                                                 @"leftPadding": @"40"}
                                       views:views]];

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"V:|[line]|"
                                       options:0 metrics:nil views:views]];
}

#pragma mark -
- (void)setupWithTimedEvent:(UntrackedPeriod *)period {
    NSTimeInterval duration = period.duration;
    NSInteger hours = duration / 60 / 60;
    NSInteger minutes = duration/60 - hours*60;
    NSInteger seconds = duration - minutes*60;
    NSString *timeString = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (long)hours, (long)minutes, (long)seconds];

    self.descriptionLabel.text = [NSString stringWithFormat:@"Inactive for %@", timeString];
}
@end
