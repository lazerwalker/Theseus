//
//  StopAnnotation.h
//  OpenData
//
//  Created by Michael Walker on 5/30/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@import MapKit;
@class Stop;

@interface StopAnnotation : NSObject<MKAnnotation>

@property (nonatomic, strong) Stop *stop;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithStop:(Stop *)stop;

@end
