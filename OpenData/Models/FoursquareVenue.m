//
//  FoursquareVenue.m
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "FoursquareVenue.h"

@implementation FoursquareVenue

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"foursquareId": @"id"};
}

@end
