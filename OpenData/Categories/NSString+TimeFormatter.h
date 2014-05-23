//
//  NSString+TimeFormatter.h
//  OpenData
//
//  Created by Michael Walker on 5/22/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeFormatter)

+ (NSString *)stringWithTimeInterval:(NSTimeInterval)interval;

@end
