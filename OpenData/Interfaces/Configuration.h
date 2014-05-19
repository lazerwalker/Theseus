//
//  Configuration.h
//  OpenData
//
//  Created by Michael Walker on 5/19/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

@property (nonatomic, readonly) NSString *foursquareClientID;
@property (nonatomic, readonly) NSString *foursquareClientSecret;

@property (nonatomic, readonly) NSString *dropboxAppSecret;
@property (nonatomic, readonly) NSString *dropboxAppKey;

@end
