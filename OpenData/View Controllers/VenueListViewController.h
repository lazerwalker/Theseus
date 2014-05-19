//
//  VenueListViewController.h
//  OpenData
//
//  Created by Michael Walker on 5/19/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@class Stop;

@interface VenueListViewController : UIViewController

@property (nonatomic, strong) Stop *stop;

@property (nonatomic, copy) void (^didTapCancelButtonBlock)();

- (id)initWithStop:(Stop *)stop;

@end
