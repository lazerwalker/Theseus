//
//  FoursquareVenue.h
//  Theseus
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@import MapKit;

@interface FoursquareClient : NSObject

- (void)fetchVenuesNearCoordinate:(CLLocationCoordinate2D)coordinate
                       completion:(void(^)(NSArray *results, NSError *error))completion;

- (void)searchFor:(NSString *)query
   nearCoordinate:(CLLocationCoordinate2D)coordinate
       completion:(void(^)(NSArray *results, NSError *error))completion;

@end
