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

#import "DayPresenter.h"
#import "Stop.h"
#import "MovementPath.h"
#import "UntrackedPeriod.h"
#import "StopTimelineCell.h"
#import "MovementPathTimelineCell.h"
#import "UntrackedPeriodTimelineCell.h"
#import "VenueListViewController.h"

#import <PivotalCoreKit/UIKit+PivotalSpecHelper.h>

@interface DayPresenter ()
@property (nonatomic, strong) NSArray *data;
@end

SpecBegin(ListViewController)

describe(@"ListViewController", ^{
    __block ListViewController *controller;
    __block DayPresenter *presenter;
    __block Stop *stop;
    __block NSIndexPath *stopIndexPath, *pathIndexPath, *untrackedIndexPath;

    beforeEach(^{
        presenter = mock([DayPresenter class]);
        stop = [Stop MR_createEntity];

        [given([presenter numberOfEvents]) willReturnInt:3];
        [given([presenter eventForIndex:0]) willReturn:stop];
        [given([presenter eventForIndex:1]) willReturn:[MovementPath MR_createEntity]];
        [given([presenter eventForIndex:2]) willReturn:[UntrackedPeriod MR_createEntity]];

        stopIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        pathIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        untrackedIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];

        controller = [[ListViewController alloc] initWithPresenter:presenter];
        [controller viewDidLoad];
    });

    describe(@"daysAgo", ^{
        it(@"should return the same value as the presenter", ^{
            [given([presenter daysAgo]) willReturnInt:1];
            expect(controller.daysAgo).to.equal(1);
        });
    });

    context(@"updating the data", ^{
        it(@"should have registered the presenter for KVO", ^{
            [MKTVerify(presenter) addObserver:controller forKeyPath:DayPresenterDataChangedKey options:0 context:nil];
        });

        it(@"should trigger a table view refresh on change", ^{
            controller.tableView = mock(UITableView.class);
            [controller observeValueForKeyPath:DayPresenterDataChangedKey ofObject:presenter change:@{} context:nil];
            [verify(controller.tableView) reloadSections:anything() withRowAnimation:UITableViewRowAnimationAutomatic];
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
        });

        describe(@"didSelectRowAtIndexPath", ^{
            context(@"when the cell is a stop cell", ^{
                beforeEach(^{
                    [controller tableView:controller.tableView didSelectRowAtIndexPath:stopIndexPath];
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
                    [controller tableView:controller.tableView didSelectRowAtIndexPath:pathIndexPath];

                    expect(controller.presentedViewController).to.beNil();
                });
            });

            context(@"when the cell is an untracked period cell", ^{
                it(@"should do nothing", ^{
                    [controller tableView:controller.tableView didSelectRowAtIndexPath:untrackedIndexPath];

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
                    expect(cell).to.beAnInstanceOf(MovementPathTimelineCell.class);
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
