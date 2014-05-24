//
//  NSString+TimeFormatterSpec.m
//  OpenData
//
//  Created by Michael Walker on 5/24/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Specta.h>
#import <Expecta.h>

#import "NSString+TimeFormatter.h"

SpecBegin(NSStringTimeFormatter)

describe(@"NSString+TimeFormatter", ^{
    describe(@"when the time is less than one hour", ^{
        it(@"should only include the minutes", ^{
            expect([NSString stringWithTimeInterval:45 * 60]).to.equal(@"45m");
        });
    });

    describe(@"when the time is an exact number of hours", ^{
        it(@"should only include the hours", ^{
            expect([NSString stringWithTimeInterval:3 * 60 * 60]).to.equal(@"3h");
        });
    });

    describe(@"when the time is longer than one hour, but not an exact number of hours", ^{
        it(@"should include both hours and minutes", ^{
            expect([NSString stringWithTimeInterval:(2 * 60 * 60) + (10 * 60)]).to.equal(@"2h10m");
        });
    });
});

SpecEnd