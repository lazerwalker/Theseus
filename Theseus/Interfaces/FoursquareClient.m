//
//  FoursquareVenue.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/13/14.
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

#import "FoursquareClient.h"
#import "FoursquareVenue.h"
#import "Configuration.h"

static NSString * const BaseURL = @"https://api.foursquare.com/v2/venues/search";
static NSString * const APIDate = @"20140513";

@interface FoursquareClient ()<NSURLConnectionDelegate>
@property (nonatomic, strong) Configuration *config;
@end

@implementation FoursquareClient

- (id)init {
    self = [super init];
    if (!self) return nil;

    self.config = [Configuration new];

    return self;
}

- (void)fetchVenuesNearCoordinate:(CLLocationCoordinate2D)coordinate
                       completion:(void(^)(NSArray *results, NSError *error))completion {
    [self makeRequest:[self searchURLForCoordinate:coordinate]
           completion:completion];
}

- (void)searchFor:(NSString *)query
   nearCoordinate:(CLLocationCoordinate2D)coordinate
       completion:(void(^)(NSArray *results, NSError *error))completion {
    [self makeRequest:[self searchURLForCoordinate:coordinate query:query]
           completion:completion];
}

#pragma mark - Private
- (NSURL *)searchURLForCoordinate:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [BaseURL stringByAppendingFormat:@"?client_id=%@&client_secret=%@&v=%@&ll=%f,%f",
                           self.config.foursquareClientID,
                           self.config.foursquareClientSecret,
                           APIDate,
                           coordinate.latitude,
                           coordinate.longitude];
    return [NSURL URLWithString:urlString];
}

- (NSURL *)searchURLForCoordinate:(CLLocationCoordinate2D)coordinate query:(NSString *)query {
    NSString *urlString = [BaseURL stringByAppendingFormat:@"?client_id=%@&client_secret=%@&v=%@&ll=%f,%f&query=%@",
                           self.config.foursquareClientID,
                           self.config.foursquareClientSecret,
                           APIDate,
                           coordinate.latitude,
                           coordinate.longitude,
                           query];
    return [NSURL URLWithString:urlString];
}

- (void)makeRequest:(NSURL *)url
            completion:(void (^)(NSArray *results, NSError *error))completion {
    [Theseus showNetworkActivitySpinner];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [Theseus hideNetworkActivitySpinner];

        if (data) {
            NSError *jsonError;
            NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];

            if (jsonError && !error) {
                error = jsonError;
            }

            NSMutableArray *mutableResults = [NSMutableArray new];
            for (NSDictionary *result in jsonResults[@"response"][@"venues"]) {
                FoursquareVenue *venue = [MTLJSONAdapter modelOfClass:FoursquareVenue.class fromJSONDictionary:result error:&error];
                [mutableResults addObject:venue];
            }

            if (completion) {
                completion([mutableResults copy], error);
            }
        }
    }];
}

@end
