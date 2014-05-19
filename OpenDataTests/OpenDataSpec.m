//
//  OpenData.m
//  OpenData
//
//  Created by Michael Walker on 5/19/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#define EXP_SHORTHAND
#import <Specta.h>
#import <Expecta.h>

#import "OpenData.h"

SpecBegin(OpenData)

describe(@"OpenData", ^{
    describe(@"the network activity spinner", ^{
        context(@"when it is not already shown", ^{
            beforeEach(^{
                [OpenData hideNetworkActivitySpinner];
            });

            it(@"should should show it", ^{
                expect(UIApplication.sharedApplication.networkActivityIndicatorVisible).to.beFalsy();
                [OpenData showNetworkActivitySpinner];
                expect(UIApplication.sharedApplication.networkActivityIndicatorVisible).to.beTruthy();
            });

            it(@"should hide it", ^{
                [OpenData showNetworkActivitySpinner];
                [OpenData hideNetworkActivitySpinner];
                expect(UIApplication.sharedApplication.networkActivityIndicatorVisible).to.beFalsy();
            });
        });

        context(@"when it has already been shown", ^{
            beforeEach(^{
                [OpenData showNetworkActivitySpinner];
            });

            afterEach(^{
                [OpenData hideNetworkActivitySpinner];
            });

            it(@"should still be shown", ^{
                expect(UIApplication.sharedApplication.networkActivityIndicatorVisible).to.beTruthy();
                [OpenData showNetworkActivitySpinner];
                expect(UIApplication.sharedApplication.networkActivityIndicatorVisible).to.beTruthy();
            });

            it(@"shouldn't hide until an appropriate number of 'hide' calls", ^{
                [OpenData hideNetworkActivitySpinner];
                expect(UIApplication.sharedApplication.networkActivityIndicatorVisible).to.beTruthy();
                [OpenData hideNetworkActivitySpinner];
            });
        });
    });
});

SpecEnd