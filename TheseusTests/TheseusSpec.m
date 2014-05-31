//
//  Theseus.m
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
#import <Specta.h>
#import <Expecta.h>

#import "Theseus.h"

SpecBegin(Theseus)

describe(@"Theseus", ^{
    describe(@"the network activity spinner", ^{
        context(@"when it is not already shown", ^{
            beforeEach(^{
                [Theseus hideNetworkActivitySpinner];
            });

            it(@"should should show it", ^{
                expect(UIApplication.sharedApplication.networkActivityIndicatorVisible).to.beFalsy();
                [Theseus showNetworkActivitySpinner];
                expect(UIApplication.sharedApplication.networkActivityIndicatorVisible).to.beTruthy();
            });

            it(@"should hide it", ^{
                [Theseus showNetworkActivitySpinner];
                [Theseus hideNetworkActivitySpinner];
                expect(UIApplication.sharedApplication.networkActivityIndicatorVisible).to.beFalsy();
            });
        });

        context(@"when it has already been shown", ^{
            beforeEach(^{
                [Theseus showNetworkActivitySpinner];
            });

            afterEach(^{
                [Theseus hideNetworkActivitySpinner];
            });

            it(@"should still be shown", ^{
                expect(UIApplication.sharedApplication.networkActivityIndicatorVisible).to.beTruthy();
                [Theseus showNetworkActivitySpinner];
                expect(UIApplication.sharedApplication.networkActivityIndicatorVisible).to.beTruthy();
            });

            it(@"shouldn't hide until an appropriate number of 'hide' calls", ^{
                [Theseus hideNetworkActivitySpinner];
                expect(UIApplication.sharedApplication.networkActivityIndicatorVisible).to.beTruthy();
                [Theseus hideNetworkActivitySpinner];
            });
        });
    });
});

SpecEnd