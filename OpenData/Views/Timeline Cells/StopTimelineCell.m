//
//  StopTimelineCell.m
//  OpenData
//
//  Created by Michael Walker on 5/22/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "StopTimelineCell.h"

@implementation StopTimelineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    [self render];

    return self;
}

- (void)render {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor blackColor];
    self.textLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.textColor = [UIColor lightGrayColor];

    UIView *line = [UIView new];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];

    NSDictionary *views = @{@"line": line,
                            @"text": self.textLabel};

    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"|-[line(lineWidth)]-[text]"
                                      options:0
                                      metrics:@{@"lineWidth": @"3.0"}
                                      views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|[line]|"
                                      options:0
                                      metrics:nil
                                      views:views]];

}

@end
