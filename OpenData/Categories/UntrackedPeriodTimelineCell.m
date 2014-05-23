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

    self.line = [UIView new];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.line];

    self.descriptionLabel = [UILabel new];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.descriptionLabel];

    self.traintrackTop = [UIView new];
    self.traintrackTop.translatesAutoresizingMaskIntoConstraints = NO;
    self.traintrackTop.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.traintrackTop];

    self.traintrackBottom = [UIView new];
    self.traintrackBottom.translatesAutoresizingMaskIntoConstraints = NO;
    self.traintrackBottom.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.traintrackBottom];

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];

    NSDictionary *views = @{@"line": self.line,
                            @"descriptionLabel": self.descriptionLabel,
                            @"traintrackTop": self.traintrackTop,
                            @"traintrackBottom": self.traintrackBottom};

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

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"V:|[traintrackTop]-(>=0)-[traintrackBottom]|"
                                       options:NSLayoutFormatAlignAllCenterX|NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight
                                       metrics:nil views:views]];

    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:self.traintrackTop
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.line
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0 constant:0]];

    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:self.traintrackTop
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:NSLayoutAttributeNotAnAttribute
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0 constant:20]];

    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:self.traintrackTop
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:NSLayoutAttributeNotAnAttribute
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0 constant:3.0]];

    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:self.traintrackBottom
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.traintrackTop
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:1.0 constant:0]];

}

#pragma mark -
- (void)setupWithTimedEvent:(UntrackedPeriod *)period {
    self.descriptionLabel.text = [NSString stringWithFormat:@"Inactive for %@", [NSString stringWithTimeInterval:period.duration]];
}
@end
