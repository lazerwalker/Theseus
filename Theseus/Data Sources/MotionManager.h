//
//  MotionManager.h
//  Theseus
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MotionManager : NSObject

- (void)startMonitoring;
- (void)stopMonitoring;
- (void)fetchUpdatesWhileInactive;

@end
