//
//  Configuration.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/19/14.
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

#import "Configuration.h"

static NSString * const FoursquareDictKey = @"FoursquareAPI";
static NSString * const DropboxDictKey = @"DropboxAPI";

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

- (NSString *)dropboxAppSecret {
    return self.plist[DropboxDictKey][@"AppSecret"];
}

- (NSString *)dropboxAppKey {
    return self.plist[DropboxDictKey][@"AppKey"];
}

@end
