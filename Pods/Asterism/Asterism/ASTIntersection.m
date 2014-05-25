//
//  ASTIntersection.m
//  Asterism
//
//  Created by Robert Böhnke on 6/18/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTIntersection.h"

NSArray *__ASTIntersection_NSArray(NSArray *array, NSArray *other) {
    if (array == nil) return other;
    if (other == nil) return array;

    NSMutableArray *result = [array mutableCopy];

    for (id obj in array) {
        if (![other containsObject:obj]) {
            [result removeObject:obj];
        }
    }

    return [result copy];
}

NSSet *__ASTIntersection_NSSet(NSSet *set, NSSet *other) {
    if (set == nil) return other;
    if (other == nil) return set;

    NSMutableSet *result = [set mutableCopy];
    [result intersectSet:other];

    return [result copy];
}

NSOrderedSet *__ASTIntersection_NSOrderedSet(NSOrderedSet *set, NSOrderedSet *other) {
    if (set == nil) return other;
    if (other == nil) return set;

    NSMutableOrderedSet *result = [set mutableCopy];
    [result intersectOrderedSet:other];

    return [result copy];
}
