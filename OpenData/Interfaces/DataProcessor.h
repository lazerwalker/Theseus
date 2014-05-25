//
//  DataProcessor.h
//  OpenData
//
//  Created by Michael Walker on 5/14/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

extern NSString *DataProcessorDidFinishProcessingNotification;

@interface DataProcessor : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)eventsForDaysAgo:(NSInteger)daysAgo;
- (void)processNewData;
- (void)reprocessData;

@end
