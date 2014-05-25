//
//  ASTIndexOf.m
//  Asterism
//
//  Created by Robert Böhnke on 24/11/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTIndexOf.h"

NSUInteger __ASTIndexOf_NSArray(NSArray *array, id obj) {
    return [array indexOfObject:obj];
}

NSUInteger __ASTIndexOf_NSOrderedSet(NSOrderedSet *set, id obj) {
    return [set indexOfObject:obj];
}

NSUInteger __ASTIndexOf_NSFastEnumeration(id<NSFastEnumeration> collection, id obj) {
    if (collection == nil || obj == nil) return NSNotFound;

    NSUInteger index = 0;

    for (id other in collection) {
        if ([obj isEqual:other]) return index;

        index++;
    }

    return NSNotFound;
}
