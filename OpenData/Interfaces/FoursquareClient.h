//
//  FoursquareVenue.h
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@import MapKit;

@interface FoursquareClient : NSObject

- (void)fetchVenuesForCoordinate:(CLLocationCoordinate2D)coordinate
                       completion:(void(^)(NSArray *results, NSError *error))completion;
@end
