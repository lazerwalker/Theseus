//
//  ASTUnion.m
//  Asterism
//
//  Created by Robert Böhnke on 6/18/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTDifference.h"

#import "ASTUnion.h"

NSArray *__ASTUnion_NSArray(NSArray *array, NSArray *other) {
    if (array == nil) return other;
    if (other == nil) return array;

    return [array arrayByAddingObjectsFromArray:ASTDifference(other, array)];
}

NSSet *__ASTUnion_NSSet(NSSet *set, NSSet *other) {
    if (set == nil) return other;
    if (other == nil) return set;

    return [set setByAddingObjectsFromSet:other];
}

NSOrderedSet *__ASTUnion_NSOrderedSet(NSOrderedSet *set, NSOrderedSet *other) {
    if (set == nil) return other;
    if (other == nil) return set;

    NSMutableOrderedSet *result = [set mutableCopy];
    [result unionOrderedSet:other];

    return result;
}
