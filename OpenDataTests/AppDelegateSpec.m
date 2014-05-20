//
//  AppDelegateSpec.m
//  OpenData
//
//  Created by Michael Walker on 5/19/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#define EXP_SHORTHAND
#import <Specta.h>
#import <Expecta.h>
#import "AppDelegate.h"
#import <DropboxSDK.h>

SpecBegin(AppDelegate)

describe(@"AppDelegate", ^{
    __block AppDelegate *appDelegate;
    
    beforeEach(^{
        appDelegate = [AppDelegate new];
    });

    describe(@"didFinishLaunchingWithOptions:", ^{
        beforeEach(^{
            [appDelegate application:UIApplication.sharedApplication didFinishLaunchingWithOptions:nil];
        });

        /** TODO: There's an incredibly bizarre bug here. 
         If you place a breakpoint inside the it block, `DBSession.sharedSession` exists and is not nil.
         If you place a NSLog inside, it prints out as nil.
         What's going on? */
        xdescribe(@"setting up Dropbox", ^{
            it(@"should set up a shared session", ^{
                expect(DBSession.sharedSession).notTo.beNil();
            });
        });
    });
});

SpecEnd