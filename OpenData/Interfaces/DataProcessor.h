//
//  DataProcessor.h
//  OpenData
//
//  Created by Michael Walker on 5/14/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//


@interface DataProcessor : NSObject

- (void)processDataWithCompletion:(void(^)(NSArray *stops, NSArray *paths))completion;
@end
