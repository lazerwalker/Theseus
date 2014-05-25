//
//  DayPresenter.m
//  OpenData
//
//  Created by Michael Walker on 5/23/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "Day.h"
#import "DataProcessor.h"

NSString * const DayDataChangedKey = @"DayDataChangedKey";

@interface Day ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation Day

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

- (id)initWithDaysAgo:(NSUInteger)daysAgo {
    self = [super init];
    if (!self) return nil;

    self.daysAgo = daysAgo;
    [self fetch];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetch) name:DataProcessorDidFinishProcessingNotification object:nil];

    return self;
}

- (void)fetch {
    self.data = [DataProcessor.sharedInstance eventsForDaysAgo:self.daysAgo];
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
