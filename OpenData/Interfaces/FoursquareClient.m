//
//  FoursquareVenue.m
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "FoursquareClient.h"
#import "FoursquareVenue.h"

static NSString * const BaseURL = @"https://api.foursquare.com/v2/venues/search";
static NSString * const APIDate = @"20140513";

@interface FoursquareClient ()<NSURLConnectionDelegate>

@end

@implementation FoursquareClient

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
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configuration = [[NSDictionary alloc] initWithContentsOfFile:plistPath];

    NSString *clientId = configuration[@"FoursquareAPI"][@"ClientID"];
    NSString *clientSecret = configuration[@"FoursquareAPI"][@"ClientSecret"];

    NSString *urlString = [BaseURL stringByAppendingFormat:@"?client_id=%@&client_secret=%@&v=%@&ll=%f,%f", clientId, clientSecret, APIDate, coordinate.latitude, coordinate.longitude];
    return [NSURL URLWithString:urlString];
}

- (NSURL *)searchURLForCoordinate:(CLLocationCoordinate2D)coordinate query:(NSString *)query {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configuration = [[NSDictionary alloc] initWithContentsOfFile:plistPath];

    NSString *clientId = configuration[@"FoursquareAPI"][@"ClientID"];
    NSString *clientSecret = configuration[@"FoursquareAPI"][@"ClientSecret"];

    NSString *urlString = [BaseURL stringByAppendingFormat:@"?client_id=%@&client_secret=%@&v=%@&ll=%f,%f&query=%@", clientId, clientSecret, APIDate, coordinate.latitude, coordinate.longitude, query];
    return [NSURL URLWithString:urlString];
}

- (void)makeRequest:(NSURL *)url
            completion:(void (^)(NSArray *results, NSError *error))completion {
    [OpenData showNetworkActivitySpinner];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [OpenData hideNetworkActivitySpinner];

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
