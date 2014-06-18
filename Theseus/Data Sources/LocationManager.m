//
//  LocationManager.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/12/14.
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

#import "LocationManager.h"
#import "RawLocation.h"
#import "Stop.h"

extern NSString *TheseusDidProcessNewDataNotification;

@import CoreLocation;

@interface LocationManager ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *manager;
@end

@implementation LocationManager

- (id)init {
    self = [super init];
    if (!self) return nil;

    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.pausesLocationUpdatesAutomatically = NO;
    self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    return self;
}

- (void)startMonitoring {
    if (![CLLocationManager locationServicesEnabled]) return;

    [self.manager startUpdatingLocation];
    [self.manager startMonitoringVisits];
}

- (void)stopMonitoring {
    [self.manager stopUpdatingLocation];
    [self.manager stopMonitoringVisits];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        Stop *stop = [[Stop alloc] initWithContext:localContext];
        [stop setupWithVisit:visit];
        [[NSNotificationCenter defaultCenter] postNotificationName:TheseusDidProcessNewDataNotification object:self];
    }];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (CLLocation *location in locations) {
            RawLocation *rawLocation = [[RawLocation alloc] initWithContext:localContext];
            [rawLocation setupWithLocation:location];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"LOCATIONERROR ================> %@", error);
}

@end
