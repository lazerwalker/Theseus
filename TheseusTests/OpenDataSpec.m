//
//  Theseus.m
//  Theseus
//
//  Created by Michael Walker on 5/19/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

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