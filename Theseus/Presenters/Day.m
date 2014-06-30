//
//  DayPresenter.m
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

#import "Day.h"
#import "TimedEvent.h"
#import "Path.h"
#import "Stop.h"
#import "StepCount.h"

#import "NSDate+DaysAgo.h"
#import <Asterism.h>

NSString * const TheseusDidProcessNewDataLocation = @"TheseusDidProcessNewDataLocation";
NSString * const TheseusDidProcessNewDataStep = @"TheseusDidProcessNewDataStep";

NSString * const DayDataChangedKey = @"data";
NSString * const DayStepsChangedKey = @"steps";

@interface Day ()
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, readwrite) NSDate *date;
@property (nonatomic, readwrite, assign) NSInteger steps;
@end

@implementation Day

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"daysAgo": NSNull.null};
}

+ (NSValueTransformer *)dataJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:TimedEvent.class];
}

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

- (id)initWithDaysAgo:(NSUInteger)daysAgo {
    self = [super init];
    if (!self) return nil;

    self.daysAgo = daysAgo;
    self.date = [[NSDate alloc] initWithDaysAgo:daysAgo];

    [self fetchStops];
    [self fetchSteps];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchStops) name:TheseusDidProcessNewDataLocation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedSteps:) name:TheseusDidProcessNewDataStep object:nil];

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)fetchStops {
    NSDate *startOfDay = [[NSDate alloc] initWithDaysAgo:self.daysAgo];
    NSDate *endOfDay = startOfDay.endOfDay;
    
        NSPredicate *day = [NSPredicate predicateWithFormat:@"(startTime > %@) AND (endTime < %@)", startOfDay, endOfDay];

    self.data = [Stop MR_findAllSortedBy:@"startTime" ascending:YES withPredicate:day];
}

- (void)fetchSteps {
    self.steps = [[StepCount forDate:self.date] count];
}

- (void)updatedSteps:(NSNotification *)notification {
    NSDate *stepDate = notification.object;
    if ([stepDate isEqualToDate:self.date]) {
        [self fetchSteps];
    }
}


- (NSArray *)paths {
    return ASTFilter(self.data, ^BOOL(TimedEvent *obj) {
        return [obj isKindOfClass:Path.class];
    });
}

- (NSArray *)stops {
    return ASTFilter(self.data, ^BOOL(TimedEvent *obj) {
        return [obj isKindOfClass:Stop.class];
    });
}

- (NSString *)jsonRepresentation {
    NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:self];
    NSError *error;

    NSData *jsonData;
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    }

    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

- (NSUInteger)numberOfEvents {
    return self.data.count;
}

- (NSString *)title {
    if (self.daysAgo == 0) {
        return @"Today";
    } else if (self.daysAgo == 1) {
        return @"Yesterday";
    } else {
        return [NSString stringWithFormat:@"%lu Days Ago", (long)self.daysAgo];
    }
}

- (TimedEvent *)eventForIndex:(NSInteger)index {
    if (index < self.data.count) {
        return self.data[index];
    } else {
        return nil;
    }
}

- (MKCoordinateRegion)region {
    // TODO: This can be made more elegant by exending Asterism's `ASTFlatten` method to operate on NSSets.
    NSArray *locationSets = [self.paths valueForKeyPath:@"locations"];
    NSMutableArray *pathLocations = [NSMutableArray new];
    for (NSSet *set in locationSets) {
        [pathLocations addObjectsFromArray:set.allObjects];
    }

    NSArray *locations = [pathLocations arrayByAddingObjectsFromArray:self.stops];

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake([[locations valueForKeyPath:@"@avg.latitude"] doubleValue], [[locations valueForKeyPath:@"@avg.longitude"] doubleValue]);


    CLLocationDegrees minLat = [[locations valueForKeyPath:@"@min.latitude"] doubleValue];
    CLLocationDegrees maxLat = [[locations valueForKeyPath:@"@max.latitude"] doubleValue];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:minLat longitude:0];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:maxLat longitude:0];
    CLLocationDistance latitudeDelta = [location1 distanceFromLocation:location2];

    CLLocationDegrees minLong = [[locations valueForKeyPath:@"@min.longitude"] doubleValue];
    CLLocationDegrees maxLong = [[locations valueForKeyPath:@"@max.longitude"] doubleValue];
    location1 = [[CLLocation alloc] initWithLatitude:0 longitude:minLong];
    location2 = [[CLLocation alloc] initWithLatitude:0 longitude:maxLong];
    CLLocationDistance longitudeDelta = [location1 distanceFromLocation:location2];

    return MKCoordinateRegionMakeWithDistance(center, latitudeDelta, longitudeDelta);
}


@end
