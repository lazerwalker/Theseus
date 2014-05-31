//
//  AppDelegateSpec.m
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