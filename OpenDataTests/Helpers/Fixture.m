//
//  Fixture.m
//  OpenData
//
//  Created by Michael Walker on 5/27/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

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
