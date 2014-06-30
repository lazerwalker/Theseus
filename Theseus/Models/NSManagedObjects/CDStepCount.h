//
//  CDStepCount.h
//  Theseus
//
//  Created by Michael Walker on 6/30/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDStepCount : NSManagedObject

@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, retain) NSDate *date;

@end
