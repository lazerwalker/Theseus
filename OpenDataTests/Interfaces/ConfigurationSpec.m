//
//  ConfigurationSpec.m
//  OpenData
//
//  Created by Michael Walker on 5/19/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import <Specta.h>
#import <Expecta.h>

#import "Configuration.h"

@interface Configuration (Spec)
- (id)initWithBundle:(NSBundle *)bundle;
@end

SpecBegin(Configuration)

describe(@"Configuration", ^{
    __block Configuration *config;

    beforeEach(^{
        config = [Configuration new];
    });

    context(@"when a valid configuration plist exists", ^{
        beforeEach(^{
            NSBundle *bundle = mock([NSBundle class]);
            NSString *actualFilepath = [NSBundle.mainBundle pathForResource:@"Configuration.plist" ofType:@"example"];
            [given([bundle pathForResource:@"Configuration" ofType:@"plist"]) willReturn:actualFilepath];
            config = [[Configuration alloc] initWithBundle:bundle];
        });

        it(@"should load foursquare client ID and secret", ^{
            expect(config.foursquareClientID).toNot.beNil();
            expect(config.foursquareClientSecret).toNot.beNil();
        });
    });

    context(@"when no valid plist exists", ^{
        it(@"should raise an exception", ^{
            expect(^{
                NSBundle *bundle = mock([NSBundle class]);
                [given([bundle pathForResource:@"Configuration" ofType:@"plist"]) willReturn:nil];
                config = [[Configuration alloc] initWithBundle:bundle];
            }).to.raiseAny();
        });
    });
});

SpecEnd
