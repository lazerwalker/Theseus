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
    return @{@"foursquareId": @"id",
             @"iconPrefix": @"categories.icon.prefix",
             @"iconSuffix": @"categories.icon.suffix"};
}

- (NSURL *)iconURL {
    NSString *url = [NSString stringWithFormat:@"%@bg_64%@", self.iconPrefix.firstObject, self.iconSuffix.firstObject];
    return [NSURL URLWithString:url];
}
@end
