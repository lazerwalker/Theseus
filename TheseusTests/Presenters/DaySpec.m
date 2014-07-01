//
//  Day.m
//  Theseus
//
//  Created by Michael Walker on 6/30/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//
//  Created by Mike Lazer-Walker on 5/30/14.
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

#import "Day.h"

SpecBegin(Day)

describe(@"Day", ^{
    __block Day *day;

    beforeEach(^{
        day = [[Day alloc] initWithDaysAgo:0];
    });

    describe(@"title", ^{
        context(@"when it is today", ^{
            beforeEach(^{
                day = [[Day alloc] initWithDaysAgo:0];
            });

            it(@"should be 'Today'", ^{
                expect(day.title).to.equal(@"Today");
            });
        });

        context(@"when it is yesterday", ^{
            beforeEach(^{
                day = [[Day alloc] initWithDaysAgo:1];
            });

            it(@"should be 'Yesterday'", ^{
                expect(day.title).to.equal(@"Yesterday");
            });
        });

        context(@"when it is earlier than yesterday", ^{
            beforeEach(^{
                day = [[Day alloc] initWithDaysAgo:4];
            });

            it(@"should show the number of days", ^{
                expect(day.title).to.equal(@"4 Days Ago");
            });
        });
    });

    // TODO: Implementing these two tests easily requires a better way to create new data without a MR dependency
    xdescribe(@"updating the list of events", ^{
        context(@"when a new event notification is triggered", ^{
            beforeEach(^{
                [NSNotificationCenter.defaultCenter postNotificationName:TheseusDidProcessNewDataLocation object:nil];
            });

            it(@"should re-fetch events", ^{
            });
        });
    });

    xdescribe(@"updating the step count", ^{
        context(@"when a new step notification is triggered", ^{
            context(@"when the notification is for the correct day", ^{
                beforeEach(^{
                    [NSNotificationCenter.defaultCenter postNotificationName:TheseusDidProcessNewDataStep object:day.date];
                });

                it(@"should re-fetch the step count", ^{
                });
            });

            context(@"when the notification is not for the correct day", ^{
                beforeEach(^{
                    [NSNotificationCenter.defaultCenter postNotificationName:TheseusDidProcessNewDataStep object:day.date.endOfDay];
                });

                it(@"should do nothing", ^{

                });
            });
        });
    });

    xdescribe(@"getting events", ^{
        describe(@"number of events", ^{
            it(@"should return the correct number of events", ^{

            });
        });

        describe(@"getting a specific event", ^{
            it(@"should return the correct event for a given index", ^{
            });
        });

        describe(@"getting only events of a certain type", ^{
            describe(@"getting stops", ^{
                it(@"should only return stops", ^{

                });
            });

            describe(@"getting paths", ^{
                it(@"should only return paths", ^{

                });
            });
        });
    });

    xdescribe(@"serializing to JSON", ^{
    });

    xdescribe(@"map region", ^{
    });
});

SpecEnd