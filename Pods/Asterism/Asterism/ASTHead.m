//
//  ASTHead.m
//  Asterism
//
//  Created by Robert Böhnke on 6/1/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTHead.h"

id __ASTHead_NSArray(NSArray *array) {
    return array.count > 0 ? array[0] : nil;
}

id __ASTHead_NSOrderedSet(NSOrderedSet *set) {
    return set.count > 0 ? set[0] : nil;
}
