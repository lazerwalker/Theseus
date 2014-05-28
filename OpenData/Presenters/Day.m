//
//  DayPresenter.m
//  OpenData
//
//  Created by Michael Walker on 5/23/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "Day.h"
#import "DataProcessor.h"
#import "TimedEvent.h"

NSString * const DayDataChangedKey = @"DayDataChangedKey";

@interface Day ()
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, readwrite) NSDate *date;
@end

@implementation Day

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"daysAgo": NSNull.null};
}

+ (NSValueTransformer *)dataJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:TimedEvent.class];
}

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

- (id)initWithDaysAgo:(NSUInteger)daysAgo {
    self = [super init];
    if (!self) return nil;

    self.daysAgo = daysAgo;
    self.date = ({
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:NSDate.date];
        components.day -= daysAgo;
        [calendar dateFromComponents:components];
    });

    [self fetch];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetch) name:DataProcessorDidFinishProcessingNotification object:nil];

    return self;
}

- (void)fetch {
    self.data = [DataProcessor.sharedInstance eventsForDaysAgo:self.daysAgo];
}

- (NSString *)jsonRepresentation {
    NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:self];
    NSError *error;

    NSData *jsonData;
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    }

    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

- (NSUInteger)numberOfEvents {
    return self.data.count;
}

- (NSString *)title {
    if (self.daysAgo == 0) {
        return @"Today";
    } else if (self.daysAgo == 1) {
        return @"Yesterday";
    } else {
        return [NSString stringWithFormat:@"%lu Days Ago", (long)self.daysAgo];
    }
}

- (TimedEvent *)eventForIndex:(NSInteger)index {
    if (index < self.data.count) {
        return self.data[index];
    } else {
        return nil;
    }
}

@end
