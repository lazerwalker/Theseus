//
//  DaysAgoDataSource.h
//  OpenData
//
//  Created by Michael Walker on 5/23/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaysAgoDataSource : NSObject<UIPageViewControllerDataSource>

- (UIViewController *)controllerForDaysAgo:(NSInteger)daysAgo;

@end
