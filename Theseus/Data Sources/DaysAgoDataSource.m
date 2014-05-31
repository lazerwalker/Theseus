//
//  DaysAgoDataSource.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/23/14.
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
