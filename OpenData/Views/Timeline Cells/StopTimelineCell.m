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
@end

@implementation StopTimelineCell

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
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

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];

    NSDictionary *views = @{@"line": self.line,
                            @"venueLabel": self.venueLabel};

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"|-[line(lineWidth)]-[venueLabel]-|"
                                       options:NSLayoutFormatAlignAllCenterY
                                       metrics:@{@"lineWidth": @"3.0"}
                                       views:views]];

    [self.contentView addConstraints: [NSLayoutConstraint
                                       constraintsWithVisualFormat:@"V:|[line]|"
                                       options:0
                                       metrics:nil
                                       views:views]];
}

#pragma mark -

- (void)setupWithTimedEvent:(Stop *)stop {
    if (![stop isKindOfClass:Stop.class]) return;

    if (stop.venue) {
        self.venueLabel.text = stop.venue.name;
    } else {
        self.venueLabel.text = [NSString stringWithFormat:@"%f, %f", stop.coordinate.latitude, stop.coordinate.longitude];
    }
}
@end
