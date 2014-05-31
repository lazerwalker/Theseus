//
//  StopTimelineCell.m
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

#import "StopTimelineCell.h"
#import "Stop.h"
#import "Venue.h"

#import <FAKFontAwesome.h>

static CGFloat EditIconSize = 18.0;

@interface StopTimelineCell ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *bubble;
@property (nonatomic, strong) UILabel *venueLabel;

@property (nonatomic, strong) UILabel *startTime;
@property (nonatomic, strong) UILabel *endTime;

@property (nonatomic, weak) Stop *stop;
@end

@implementation StopTimelineCell

+ (CGFloat)heightForTimedEvent:(Stop *)stop {
    CGFloat duration = stop.duration / 60;
    duration = MIN(duration, TimelineCellHeightMax);
    return MAX(TimelineCellHeightDefault, duration);
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"h:mm";
    });

    return _dateFormatter;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    [self render];

    return self;
}

- (void)render {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    FAKFontAwesome *pencil = [FAKFontAwesome pencilIconWithSize:EditIconSize];
    [pencil addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *editIcon = [pencil imageWithSize:CGSizeMake(30.0, 30.0)];
    self.accessoryView = [[UIImageView alloc] initWithImage:editIcon];
    self.accessoryView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAccessoryView)];
    [self.accessoryView addGestureRecognizer:tapRecognizer];

    self.line = [UIView new];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.line];

    self.bubble = [UIView new];
    self.bubble.translatesAutoresizingMaskIntoConstraints = NO;
    self.bubble.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
    self.bubble.layer.cornerRadius = 5.0;
    [self.contentView addSubview:self.bubble];

    self.venueLabel = [UILabel new];
    self.venueLabel.adjustsFontSizeToFitWidth = YES;
    self.venueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.venueLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:22.0];
    [self.contentView addSubview:self.venueLabel];

    self.startTime = [UILabel new];
    self.startTime.translatesAutoresizingMaskIntoConstraints = NO;
    self.startTime.font = [UIFont fontWithName:@"STHeitiTC-Light" size:10.0];
    [self.contentView addSubview:self.startTime];

    self.endTime = [UILabel new];
    self.endTime.translatesAutoresizingMaskIntoConstraints = NO;
    self.endTime.font = [UIFont fontWithName:@"STHeitiTC-Light" size:10.0];
    [self.contentView addSubview:self.endTime];

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];

    NSDictionary *views = @{@"line": self.line,
                            @"venueLabel": self.venueLabel,
                            @"startTime": self.startTime,
                            @"endTime": self.endTime
                        };

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"|-(==leftPadding)-[line(lineWidth)]-(==rightPadding)-[venueLabel]-|"
                                       options:NSLayoutFormatAlignAllCenterY
                                       metrics:@{@"lineWidth": TimelineLineWidth,
                                                 @"leftPadding": TimelineLineLeftPadding,
                                                 @"rightPadding": TimelineLineRightPadding}
                                       views:views]];

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"V:|[line]|"
                                       options:0 metrics:nil views:views]];

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"[startTime]-(==15)-[line]"
                                       options:0 metrics:nil views:views]];

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"V:|[startTime]-(>=0)-[endTime]|"
                                       options:NSLayoutFormatAlignAllRight
                                       metrics:nil views:views]];

    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:self.bubble
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.line
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0 constant:0]];

    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:self.bubble
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.line
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0 constant:0]];

    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:self.bubble
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.line
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0 constant:0]];

    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:self.bubble
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.line
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1.0 constant:10]];
}

#pragma mark -

- (void)setupWithTimedEvent:(Stop *)stop {
    if (![stop isKindOfClass:Stop.class]) return;

    self.stop = stop;

    if (stop.venue) {
        self.venueLabel.text = stop.venue.name;
    } else {
        self.venueLabel.text = [NSString stringWithFormat:@"%f, %f", stop.coordinate.latitude, stop.coordinate.longitude];
    }

    self.startTime.text = [self.class.dateFormatter stringFromDate:stop.startTime];
    self.endTime.text = [self.class.dateFormatter stringFromDate:stop.endTime];

    if (self.isNow) {
        self.endTime.text = @"Now";
    }

    [self.startTime sizeToFit];
    [self.endTime sizeToFit];
}

#pragma mark - 

- (void)didTapAccessoryView {
    if (self.delegate) {
        [self.delegate didTapAccessoryViewForTimedEvent:self.stop];
    }
}
@end
