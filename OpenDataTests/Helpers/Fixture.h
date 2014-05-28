//
//  Fixture.h
//  OpenData
//
//  Created by Michael Walker on 5/27/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fixture : NSObject

+ (void)clearData;
+ (void)loadFixtureNamed:(NSString *)name;

@end
