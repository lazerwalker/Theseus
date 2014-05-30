//
//  StopAnnotation.m
//  OpenData
//
//  Created by Michael Walker on 5/30/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "StopAnnotation.h"
#import "Stop.h"
#import "Venue.h"

#import "NSString+TimeFormatter.h"

@implementation StopAnnotation

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"h:mm";
    });

    return _dateFormatter;
}

- (id)initWithStop:(Stop *)stop {
    if (!(self = [super init])) return nil;

    self.stop = stop;
    
    self.subtitle = [NSString stringWithFormat:@"%@ - %@ (%@)", [self.dateFormatter stringFromDate:stop.startTime], [self.dateFormatter stringFromDate:stop.endTime], [NSString stringWithTimeInterval:stop.duration]];

    self.coordinate = stop.coordinate;

    return self;
}

- (NSString *)title {
    if (self.stop.venue) {
        return self.stop.venue.name;
    }
    return @"Unidentified Location";
}


@end
