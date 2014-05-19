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

- (void)fetchVenuesForCoordinate:(CLLocationCoordinate2D)coordinate
                       completion:(void(^)(NSArray *results, NSError *error))completion {
    [OpenData showNetworkActivitySpinner];
    NSURLRequest *request = [NSURLRequest requestWithURL:[self searchURLForCoordinate:coordinate]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [OpenData hideNetworkActivitySpinner];
        
        NSArray *results;

        if (data) {
            NSError *jsonError;
            NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];

            if (jsonError && !error) {
                error = jsonError;
            }

            if (jsonResults) {
                NSMutableArray *mutableResults = [NSMutableArray new];
                for (NSDictionary *result in jsonResults[@"response"][@"venues"]) {
                    FoursquareVenue *venue = [MTLJSONAdapter modelOfClass:FoursquareVenue.class fromJSONDictionary:result error:&error];
                    [mutableResults addObject:venue];
                }
                results = [mutableResults copy];
            }
        }

        completion(results, error);
    }];
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

@end
