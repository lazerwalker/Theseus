//
//  UntrackedPeriodTimelineCell.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/22/14.
//  Copyright (c) 2014 Mike Lazer-Walker
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>

#import "UntrackedPeriodTimelineCell.h"

#import "UntrackedPeriod.h"

#import "NSString+TimeFormatter.h"

@interface UntrackedPeriodTimelineCell ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UIView *traintrackTop;
@property (nonatomic, strong) UIView *traintrackBottom;
@property (nonatomic, strong) UIView *lineCover;

@end

@implementation UntrackedPeriodTimelineCell

+ (CGFloat)heightForTimedEvent:(UntrackedPeriod *)period {
    CGFloat duration = period.duration / 60;
    duration = MIN(duration, TimelineCellHeightMax);
    return MAX(TimelineCellHeightDefault, duration);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    [self render];

    return self;
}

- (void)render {
    self.clipsToBounds = NO;

    self.line = [UIView new];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.line];

    self.descriptionLabel = [UILabel new];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.textColor = [UIColor darkGrayColor];
    self.descriptionLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0];
    [self.contentView addSubview:self.descriptionLabel];

    // TODO: HERE BE DRAGONS. This layout code is super-ugly.
    self.traintrackTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, TimelineLineWidth.floatValue)];
    self.traintrackTop.center = CGPointMake(TimelineLineLeftPadding.floatValue + 1.5, 15);
    self.traintrackTop.backgroundColor = [UIColor darkGrayColor];
    self.traintrackTop.transform = CGAffineTransformMakeRotation(-M_PI/9);
    [self.contentView addSubview:self.traintrackTop];

    self.traintrackBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, TimelineLineWidth.floatValue)];
    self.traintrackBottom.backgroundColor = [UIColor darkGrayColor];
    self.traintrackBottom.transform = CGAffineTransformMakeRotation(-M_PI/9);
    [self.contentView addSubview:self.traintrackBottom];

    self.lineCover = [UIView new];
    self.lineCover.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.lineCover];

    [self.contentView bringSubviewToFront:self.traintrackTop];
    [self.contentView bringSubviewToFront:self.traintrackBottom];

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
                                       options:0 metrics:nil views:views]];
}

#pragma mark -
- (void)setupWithTimedEvent:(UntrackedPeriod *)period {
    self.descriptionLabel.text = [NSString stringWithFormat:@"App Inactive for %@", [NSString stringWithTimeInterval:period.duration]];

    self.traintrackBottom.center = CGPointMake(self.traintrackTop.center.x, self.contentView.bounds.size.height - self.traintrackBottom.bounds.size.height * 5);

    self.lineCover.frame = CGRectMake(TimelineLineLeftPadding.floatValue,
                                      15,
                                      TimelineLineWidth.floatValue,
                                      self.contentView.frame.size.height -
                                      TimelineLineWidth.floatValue * 5 - 15);

}
@end
