//
//  NSString+TimeFormatter.m
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


#import "NSString+TimeFormatter.h"

@implementation NSString (TimeFormatter)

+ (NSString *)stringWithTimeInterval:(NSTimeInterval)interval {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *d1 = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    NSDate *d2 = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];

    NSDateComponents *components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:d1 toDate:d2 options:0];

    NSString *minuteString = [NSString stringWithFormat:@"%lu min", (long)components.minute];
    NSString *hourString = [NSString stringWithFormat:@"%lu hr", (long)components.hour];

    if (components.hour == 0) {
        return minuteString;
    } else if (components.minute == 0){
        return hourString;
    } else {
        return [NSString stringWithFormat:@"%@ %@", hourString, minuteString];
    }
}
@end
