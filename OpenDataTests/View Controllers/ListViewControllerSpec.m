//
//  ListViewControllerSpec.m
//  OpenData
//
//  Created by Michael Walker on 5/23/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>
#import <Specta.h>
#import <Expecta.h>

#import "ListViewController.h"

#import "Day.h"
#import "Stop.h"
#import "Path.h"
#import "UntrackedPeriod.h"
#import "StopTimelineCell.h"
#import "PathTimelineCell.h"
#import "UntrackedPeriodTimelineCell.h"
#import "VenueListViewController.h"
#import "SettingsViewController.h"

#import <PivotalCoreKit/UIKit+PivotalSpecHelper.h>

@interface Day ()
@property (nonatomic, strong) NSArray *data;
@end

SpecBegin(ListViewController)

describe(@"ListViewController", ^{
    __block ListViewController *controller;
    __block UINavigationController *navController;
    __block Day *day;
    __block Stop *stop;
    __block NSIndexPath *stopIndexPath, *pathIndexPath, *untrackedIndexPath;

    beforeEach(^{
        day = mock([Day class]);
        stop = [Stop new];

        [given([day numberOfEvents]) willReturnInt:3];
        [given([day eventForIndex:0]) willReturn:stop];
        [given([day eventForIndex:1]) willReturn:[Path new]];
        [given([day eventForIndex:2]) willReturn:[UntrackedPeriod new]];

        stopIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        pathIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        untrackedIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];

        controller = [[ListViewController alloc] initWithDay:day];
        navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [controller viewDidLoad];
    });

    describe(@"tapping the settings button", ^{
        it(@"should display the settings view", ^{
            [controller.navigationItem.rightBarButtonItem tap];
            expect(navController.topViewController).to.beInstanceOf(SettingsViewController.class);
        });
    });

    describe(@"daysAgo", ^{
        it(@"should return the same value as the presenter", ^{
            [given([day daysAgo]) willReturnInt:1];
            expect(controller.daysAgo).to.equal(1);
        });
    });

    context(@"updating the data", ^{
        it(@"should have registered the presenter for KVO", ^{
            [MKTVerify(day) addObserver:controller forKeyPath:DayDataChangedKey options:0 context:nil];
        });

        it(@"should trigger a table view refresh on change", ^{
            controller.tableView = mock(UITableView.class);
            [controller observeValueForKeyPath:DayDataChangedKey ofObject:day change:@{} context:nil];
            [MKTVerify(controller.tableView) reloadSections:anything() withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    });

    describe(@"UITableViewDelegate", ^{
        describe(@"heightForRowAtIndexPath", ^{
            xcontext(@"when the cell is a stop", ^{

            });

            context(@"when the cell is a movement path", ^{
                it(@"should return the default", ^{
                    CGFloat height = [controller tableView:controller.tableView heightForRowAtIndexPath:pathIndexPath];
                    expect(height).to.equal(44.0);
                });
            });

            context(@"when the cell is an untracked period", ^{
                it(@"should return the default", ^{
                    CGFloat height = [controller tableView:controller.tableView heightForRowAtIndexPath:untrackedIndexPath];
                    expect(height).to.equal(44.0);
                });
            });
        });

        describe(@"willDisplayCell", ^{
            it(@"should set up the cell", ^{
                UITableViewCell *cell = mock(StopTimelineCell.class);
                [controller tableView:controller.tableView willDisplayCell:cell forRowAtIndexPath:stopIndexPath];

                [MKTVerify(cell) setupWithTimedEvent:stop];
            });

            context(@"the first cell", ^{
                it(@"should set the cell's isFirstEvent property", ^{
                    UITableViewCell *cell = mock(StopTimelineCell.class);
                    [controller tableView:controller.tableView willDisplayCell:cell forRowAtIndexPath:stopIndexPath];

                    [MKTVerify(cell) setIsFirstEvent:YES];
                });
            });

            context(@"the last cell", ^{
                context(@"when the controller is a 'today' controller", ^{
                    it(@"should set the cell's isNow property", ^{
                        [given([day daysAgo]) willReturnInt:0];
                        UITableViewCell *cell = mock(StopTimelineCell.class);
                        [controller tableView:controller.tableView willDisplayCell:cell forRowAtIndexPath:untrackedIndexPath];

                        [MKTVerify(cell) setIsNow:YES];
                    });
                });

                context(@"when the controller is a past controller", ^{
                    it(@"should not set the cell's isNow property", ^{
                        [given([day daysAgo]) willReturnInt:1];
                        UITableViewCell *cell = mock(StopTimelineCell.class);
                        [controller tableView:controller.tableView willDisplayCell:cell forRowAtIndexPath:untrackedIndexPath];

                        [MKTVerifyCount(cell, never()) setIsNow:YES];
                    });
                });
            });
        });

        describe(@"didTapAccessoryView", ^{
            context(@"when the cell is a stop cell", ^{
                beforeEach(^{
                    [controller didTapAccessoryViewForTimedEvent:stop];
                });

                it(@"should display a venue selector", ^{
                    UINavigationController *presentedController = (UINavigationController *)controller.presentedViewController;
                    expect(presentedController).to.beKindOf(UINavigationController.class);

                    VenueListViewController *venueList = (VenueListViewController *)presentedController.topViewController;
                    expect(venueList).to.beInstanceOf(VenueListViewController.class);
                    expect(venueList.stop).to.equal(stop);
                });

                context(@"tapping the close button", ^{
                    it(@"should close the selector", ^{
                        UINavigationController *presentedController = (UINavigationController *)controller.presentedViewController;
                        VenueListViewController *venueList = (VenueListViewController *)presentedController.topViewController;

                        venueList.didTapCancelButtonBlock();

                        expect(controller.presentedViewController).to.beNil();
                    });
                });

                context(@"tapping a venue", ^{
                    it(@"should close the selector", ^{
                        UINavigationController *presentedController = (UINavigationController *)controller.presentedViewController;
                        VenueListViewController *venueList = (VenueListViewController *)presentedController.topViewController;

                        venueList.didSelectVenueBlock(nil);

                        expect(controller.presentedViewController).to.beNil();
                    });

                    xit(@"should save the venue", ^{

                    });
                });
            });

            context(@"when the cell is a movement path cell", ^{
                it(@"should do nothing", ^{
                    [controller didTapAccessoryViewForTimedEvent:[Path new]];

                    expect(controller.presentedViewController).to.beNil();
                });
            });

            context(@"when the cell is an untracked period cell", ^{
                it(@"should do nothing", ^{
                    [controller didTapAccessoryViewForTimedEvent:[UntrackedPeriod new]];

                    expect(controller.presentedViewController).to.beNil();
                });
            });
        });
    });

    describe(@"UITableViewDataSource", ^{
        describe(@"numberOfRowsInSection:", ^{
            it(@"should return the number of rows", ^{
                expect([controller tableView:controller.tableView numberOfRowsInSection:0]).to.equal(3);
            });
        });

        describe(@"cellForRowAtIndexPath", ^{
            context(@"when the event is a Stop", ^{
                it(@"should return a Stop cell", ^{
                    UITableViewCell *cell = [controller tableView:controller.tableView cellForRowAtIndexPath:stopIndexPath];
                    expect(cell).to.beAnInstanceOf(StopTimelineCell.class);
                });
            });

            context(@"when the event is a MovementPath", ^{
                it(@"should return a Stop cell", ^{
                    UITableViewCell *cell = [controller tableView:controller.tableView cellForRowAtIndexPath:pathIndexPath];
                    expect(cell).to.beAnInstanceOf(PathTimelineCell.class);
                });
            });

            context(@"when the event is an UntrackedPeriod", ^{
                it(@"should return a Stop cell", ^{
                    UITableViewCell *cell = [controller tableView:controller.tableView cellForRowAtIndexPath:untrackedIndexPath];
                    expect(cell).to.beAnInstanceOf(UntrackedPeriodTimelineCell.class);
                });
            });
        });
    });
});

SpecEnd
