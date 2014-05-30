//
//  PathPolylineSpec.m
//  OpenData
//
//  Created by Michael Walker on 5/30/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

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