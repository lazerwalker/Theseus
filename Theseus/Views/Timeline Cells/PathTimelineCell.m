//
//  MovementPathTimelineCell.m
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

#import "PathTimelineCell.h"
#import "Path.h"

#import "NSString+TimeFormatter.h"

@interface PathTimelineCell ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) UILabel *startTime;

@end

@implementation PathTimelineCell

+ (CGFloat)heightForTimedEvent:(Path *)path {
    CGFloat duration = path.duration / 60;
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
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.line = [UIView new];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.line];

    self.descriptionLabel = [UILabel new];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.textColor = [UIColor darkGrayColor];
    self.descriptionLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12.0];

    [self.contentView addSubview:self.descriptionLabel];

    self.startTime = [UILabel new];
    self.startTime.translatesAutoresizingMaskIntoConstraints = NO;
    self.startTime.font = [UIFont fontWithName:@"STHeitiTC-Light" size:10.0];
    [self.contentView addSubview:self.startTime];

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];

    NSDictionary *views = @{@"line": self.line,
                            @"descriptionLabel": self.descriptionLabel,
                            @"startTime": self.startTime};

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

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"[startTime]-(==15)-[line]"
                                       options:0 metrics:nil views:views]];
}

#pragma mark -

- (void)setupWithTimedEvent:(Path *)path {
     self.descriptionLabel.text = [NSString stringWithFormat:@"Moving for %@", [NSString stringWithTimeInterval:path.duration]];

    if (self.isFirstEvent) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"h:mm";

        self.startTime.hidden = NO;
        self.startTime.text = [dateFormatter stringFromDate:path.startTime];
    } else {
        self.startTime.hidden = YES;
    }
}
@end
