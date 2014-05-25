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
    return TimelineCellHeightDefault;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    [self render];

    return self;
}

- (void)render {
    [self applyDefaultStyles];

    self.clipsToBounds = NO;

    self.line = [UIView new];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.line];

    self.descriptionLabel = [UILabel new];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.descriptionLabel];

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
    self.descriptionLabel.text = [NSString stringWithFormat:@"Inactive for %@", [NSString stringWithTimeInterval:period.duration]];

    self.traintrackBottom.center = CGPointMake(self.traintrackTop.center.x, self.contentView.bounds.size.height - self.traintrackBottom.bounds.size.height * 5);

    self.lineCover.frame = CGRectMake(TimelineLineLeftPadding.floatValue,
                                      15,
                                      TimelineLineWidth.floatValue,
                                      self.contentView.frame.size.height -
                                      TimelineLineWidth.floatValue * 5 - 15);

}
@end
