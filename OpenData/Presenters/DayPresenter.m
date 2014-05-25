//
//  DayPresenter.m
//  OpenData
//
//  Created by Michael Walker on 5/23/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "DayPresenter.h"
#import "DataProcessor.h"

NSString * const DayPresenterDataChangedKey = @"DayPresenterDataChangedKey";

@interface DayPresenter ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation DayPresenter

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

- (NSString *)dayTitle {
    if (self.daysAgo == 0) {
        return @"Today";
    } else if (self.daysAgo == 1) {
        return @"Yesterday";
    } else {
        return [NSString stringWithFormat:@"%lu Days Ago", (long)self.daysAgo];
    }
}

- (TimedEvent *)eventForIndex:(NSInteger)index {
    return self.data[index];
}

@end
