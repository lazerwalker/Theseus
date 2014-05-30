//
//  UITableViewCell+ReuseIdentifier.m
//  Theseus
//
//  Created by Michael Walker on 5/22/14.
//  Copyright (c) 2014 Lazer-Walker. All rights reserved.
//

#import "UITableViewCell+ReuseIdentifier.h"

@implementation UITableViewCell (ReuseIdentifier)

+ (NSString *)classReuseIdentifier {
    return NSStringFromClass(self);
}

@end
