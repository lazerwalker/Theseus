//
//  PathPolylineSpec.m
//  Theseus
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

#import "PathPolyline.h"
#import "Path.h"
#import "RawLocation.h"

SpecBegin(PathPolyline)

describe(@"PathPolyline", ^{
    describe(@"initializing from a Path", ^{
        it(@"should return a valid PathPolyline", ^{
            PathPolyline *polyline = [PathPolyline polylineWithPath:[Path new]];
            expect(polyline).to.beInstanceOf(PathPolyline.class);
        });

        it(@"should have the same type as the path", ^{
            Path *path = mock(Path.class);
            [given(path.type) willReturnInteger:MovementTypeRunning];
            PathPolyline *polyline = [PathPolyline polylineWithPath:path];

            expect(polyline.type).to.equal(MovementTypeRunning);
        });
    });
});

SpecEnd