//
//  NSString+TimeFormatter.m
//  OpenData
//
//  Created by Michael Walker on 5/22/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

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
