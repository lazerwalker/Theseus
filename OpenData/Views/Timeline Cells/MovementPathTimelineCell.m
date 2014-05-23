//
//  MovementPathTimelineCell.m
//  OpenData
//
//  Created by Michael Walker on 5/22/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "MovementPathTimelineCell.h"
#import "UITableViewCell+TimelineCell.h"
#import "MovementPath.h"

#import "NSString+TimeFormatter.h"

@interface MovementPathTimelineCell ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation MovementPathTimelineCell

+ (CGFloat)heightForTimedEvent:(MovementPath *)path {
    CGFloat duration = path.duration / 60;
    duration = MIN(duration, TimelineCellHeightMax);
    return MAX(TimelineCellHeightDefault, duration);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
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
                                       constraintsWithVisualFormat:@"|-(==leftPadding)-[line(lineWidth)]-(==rightPadding)-[descriptionLabel]-|"
                                       options:NSLayoutFormatAlignAllCenterY
                                       metrics:@{@"lineWidth": TimelineLineWidth,
                                                 @"leftPadding": TimelineLineLeftPadding,
                                                 @"rightPadding": TimelineLineRightPadding}
                                       views:views]];

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"V:|[line]|"
                                       options:0
                                       metrics:nil
                                       views:views]];
}

#pragma mark -

- (void)setupWithTimedEvent:(MovementPath *)path {
     self.descriptionLabel.text = [NSString stringWithFormat:@"Moving for %@", [NSString stringWithTimeInterval:path.duration]];
}
@end
