//
//  ConfigurationSpec.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/19/14.
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

        it(@"should load foursquare keys", ^{
            expect(config.foursquareClientID).toNot.beNil();
            expect(config.foursquareClientSecret).toNot.beNil();
        });

        it(@"should load dropbox keys", ^{
            expect(config.dropboxAppSecret).toNot.beNil();
            expect(config.dropboxAppKey).toNot.beNil();
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
