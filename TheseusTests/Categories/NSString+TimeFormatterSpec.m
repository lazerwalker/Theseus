//
//  NSString+TimeFormatterSpec.m
//  Theseus
//
//  Created by Mike Lazer-Walker on 5/24/14.
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
#import <OCHamcrest/OCHamcrest.h>
#import <Specta.h>
#import <Expecta.h>

#import "NSString+TimeFormatter.h"

SpecBegin(NSStringTimeFormatter)

describe(@"NSString+TimeFormatter", ^{
    describe(@"when the time is less than one hour", ^{
        it(@"should only include the minutes", ^{
            expect([NSString stringWithTimeInterval:45 * 60]).to.equal(@"45 min");
        });
    });

    describe(@"when the time is an exact number of hours", ^{
        it(@"should only include the hours", ^{
            expect([NSString stringWithTimeInterval:3 * 60 * 60]).to.equal(@"3 hr");
        });
    });

    describe(@"when the time is longer than one hour, but not an exact number of hours", ^{
        it(@"should include both hours and minutes", ^{
            expect([NSString stringWithTimeInterval:(2 * 60 * 60) + (10 * 60)]).to.equal(@"2 hr 10 min");
        });
    });
});

SpecEnd