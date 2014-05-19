//
//  VenueListViewController.h
//  OpenData
//
//  Created by Michael Walker on 5/19/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@class Stop;
@class Venue;

@interface VenueListViewController : UIViewController

@property (nonatomic, strong) Stop *stop;

@property (nonatomic, copy) void (^didTapCancelButtonBlock)();
@property (nonatomic, copy) void (^didSelectVenueBlock)(Venue *);

- (id)initWithStop:(Stop *)stop;

@end
