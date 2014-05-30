//
//  ViewController.h
//  OpenData
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@class Day;

@interface MapViewController : UIViewController

@property (nonatomic) Day *day;

- (id)initWithDay:(Day *)day;

@end
