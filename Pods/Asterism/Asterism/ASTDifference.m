//
//  ASTDifference.m
//  Asterism
//
//  Created by Robert Böhnke on 6/18/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTDifference.h"

NSArray *__ASTDifference_NSArray(NSArray *array, NSArray *other) {
    if (array == nil) return nil;
    if (other == nil) return array;

    NSMutableArray *result = [array mutableCopy];

    [result removeObjectsInArray:other];

    return [result copy];
}

NSSet *__ASTDifference_NSSet(NSSet *set, NSSet *other) {
    if (set == nil) return nil;
    if (other == nil) return set;

    NSMutableSet *result = [set mutableCopy];

    [result minusSet:other];

    return [result copy];
}

NSOrderedSet *__ASTDifference_NSOrderedSet(NSOrderedSet *set, NSOrderedSet *other) {
    if (set == nil) return nil;
    if (other == nil) return set;

    NSMutableOrderedSet *result = [set mutableCopy];

    [result minusOrderedSet:other];

    return [result copy];
}
