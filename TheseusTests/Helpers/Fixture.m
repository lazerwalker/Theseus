//
//  Fixture.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/27/14.
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

#import "Fixture.h"

#import "Stop.h"
#import "Path.h"
#import "UntrackedPeriod.h"
#import "RawLocation.h"
#import "RawMotionActivity.h"

@implementation Fixture

+ (void)clearData {
    NSArray *classes = @[Stop.class, Path.class, UntrackedPeriod.class, RawLocation.class, RawMotionActivity.class];
    for (Class klass in classes) {
        NSArray *objects = [klass MR_findAll];
        for (id obj in objects) {
            [obj destroy];
        }
    }
}

+ (void)loadFixtureNamed:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *path = [bundle pathForResource:name ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:nil];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSArray *objects = [MTLJSONAdapter modelsOfClass:RawDataPoint.class fromJSONArray:array error:nil];
        NSLog(@"Loaded %lu objects from disk", (long)objects.count);
    }];
}
@end
