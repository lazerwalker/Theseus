//
//  DataProcessor.m
//  OpenData
//
//  Created by Michael Walker on 5/27/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import <Specta.h>
#import <Expecta.h>

#import "DataProcessor.h"
#import "Fixture.h"

SpecBegin(DataProcessor)

describe(@"DataProcessor", ^{
    __block DataProcessor *processor;
    beforeEach(^{
        [Fixture clearData];
        processor = [DataProcessor new];
    });

    describe(@"Doing a full process from scratch", ^{
        beforeEach(^{
            [Fixture loadFixtureNamed:@"ProcessAll"];
        });
        
        xit(@"should do the thing", ^AsyncBlock {
            setAsyncSpecTimeout(60);
            [processor reprocessDataWithCompletion:^(BOOL success, NSError *error) {
                expect(processor.allEvents.count).to.equal(4);
                done();
            }];
        });
    });
});

SpecEnd