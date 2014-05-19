//
//  FoursquareVenue.h
//  OpenData
//
//  Created by Michael Walker on 5/13/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Mantle.h>

@interface FoursquareVenue : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *foursquareId;
@property (nonatomic, readonly) NSURL *iconURL;

@property (nonatomic, strong) NSArray *iconPrefix;
@property (nonatomic, strong) NSArray *iconSuffix;

@end
