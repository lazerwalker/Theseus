//
//  StopTimelineCell.m
//  OpenData
//
//  Created by Michael Walker on 5/22/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "StopTimelineCell.h"
#import "UITableViewCell+TimelineCell.h"

#import "Stop.h"
#import "Venue.h"

@interface StopTimelineCell ()
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *venueLabel;

@property (nonatomic, strong) UILabel *startTime;
@property (nonatomic, strong) UILabel *endTime;
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
    [self applyDefaultStyles];

    self.line = [UIView new];
    self.line.translatesAutoresizingMaskIntoConstraints = NO;
    self.line.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.line];

    self.venueLabel = [UILabel new];
    self.venueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.venueLabel];

    self.startTime = [UILabel new];
    self.startTime.translatesAutoresizingMaskIntoConstraints = NO;
    self.startTime.font = [UIFont systemFontOfSize:10.0];
    [self.contentView addSubview:self.startTime];

    self.endTime = [UILabel new];
    self.endTime.translatesAutoresizingMaskIntoConstraints = NO;
    self.endTime.font = [UIFont systemFontOfSize:10.0];
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
                                       constraintsWithVisualFormat:@"|-(==leftPadding)-[line(lineWidth)]-[venueLabel]-|"
                                       options:NSLayoutFormatAlignAllCenterY
                                       metrics:@{@"lineWidth": @"3.0",
                                                 @"leftPadding": @"40"}
                                       views:views]];

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"V:|[line]|"
                                       options:0 metrics:nil views:views]];

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"|-(==10)-[startTime]"
                                       options:0 metrics:nil views:views]];

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"V:|[startTime]-(>=0)-[endTime]|"
                                       options:NSLayoutFormatAlignAllRight
                                       metrics:nil views:views]];
}

#pragma mark -

- (void)setupWithTimedEvent:(Stop *)stop {
    if (![stop isKindOfClass:Stop.class]) return;

    if (stop.venue) {
        self.venueLabel.text = stop.venue.name;
    } else {
        self.venueLabel.text = [NSString stringWithFormat:@"%f, %f", stop.coordinate.latitude, stop.coordinate.longitude];
    }

    self.startTime.text = [self.class.dateFormatter stringFromDate:stop.startTime];
    self.endTime.text = [self.class.dateFormatter stringFromDate:stop.endTime];

    [self.startTime sizeToFit];
    [self.endTime sizeToFit];
}
@end
