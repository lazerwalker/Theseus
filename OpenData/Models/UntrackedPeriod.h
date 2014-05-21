//
//  UntrackedPeriod.h
//  OpenData
//
//  Created by Michael Walker on 5/21/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UntrackedPeriod : NSManagedObject

@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;

@property (nonatomic, readonly) NSTimeInterval duration;
@end
