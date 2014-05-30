//
//  ViewController.h
//  Theseus
//
//  Created by Michael Walker on 5/12/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

@class Day;
@class Stop;

@interface MapViewController : UIViewController

@property (nonatomic) Day *day;

- (id)initWithDay:(Day *)day;
- (void)selectAnnotationForStop:(Stop *)stop;

@end
