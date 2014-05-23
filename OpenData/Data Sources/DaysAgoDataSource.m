//
//  DaysAgoDataSource.m
//  OpenData
//
//  Created by Michael Walker on 5/23/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "DaysAgoDataSource.h"
#import "ListViewController.h"

@implementation DaysAgoDataSource

- (UIViewController *)controllerForDaysAgo:(NSInteger)daysAgo {
    ListViewController *listController = [[ListViewController alloc] initWithDaysAgo:daysAgo];
    return [[UINavigationController alloc] initWithRootViewController:listController];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
        viewControllerBeforeViewController:(UINavigationController *)viewController {

    ListViewController *currentList = (ListViewController *)[viewController topViewController];
    return [self controllerForDaysAgo:currentList.daysAgo + 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
        viewControllerAfterViewController:(UINavigationController *)viewController {
    ListViewController *currentList = (ListViewController *)[viewController topViewController];

    if (currentList.daysAgo == 0) return nil;

    return [self controllerForDaysAgo:currentList.daysAgo - 1];
}

@end
