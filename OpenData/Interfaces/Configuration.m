//
//  Configuration.m
//  OpenData
//
//  Created by Michael Walker on 5/19/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "Configuration.h"

static NSString * const FoursquareDictKey = @"FoursquareAPI";

@interface Configuration ()
@property (nonatomic, strong) NSDictionary *plist;
@end

@implementation Configuration

- (id)init {
    return [self initWithBundle:NSBundle.mainBundle];
}

- (id)initWithBundle:(NSBundle *)bundle {
    self = [super init];
    if (!self) return nil;

    NSString *plistPath = [bundle pathForResource:@"Configuration" ofType:@"plist"];
    if (plistPath == nil) {
        [NSException raise:@"FileNotFoundException" format:@"No Configuration.plist file was found. If this is a fresh copy of the project, please read the README for instructions on how to create a configuration file."];
    }
    self.plist = [[NSDictionary alloc] initWithContentsOfFile:plistPath];

    return self;
}


- (NSString *)foursquareClientID {
    return self.plist[FoursquareDictKey][@"ClientID"];
}

- (NSString *)foursquareClientSecret {
    return self.plist[FoursquareDictKey][@"ClientSecret"];
}

@end
