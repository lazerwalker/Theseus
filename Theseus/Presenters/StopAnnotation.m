//
//  StopAnnotation.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/30/14.
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
