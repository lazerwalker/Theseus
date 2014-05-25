//
//  ASTSort.m
//  Asterism
//
//  Created by Robert Böhnke on 25/03/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

#import "ASTSort.h"

#pragma mark - Helpers

static NSComparator const ASTCompare = ^NSComparisonResult(id a, id b) {
    return [a compare:b];
};

#pragma mark - Sort

NSArray *__ASTSort_NSArray(NSArray *array) {
    return __ASTSort_NSArray_comparator(array, ASTCompare);
}

NSArray *__ASTSort_NSArray_comparator(NSArray *array, NSComparator comparator) {
    NSCParameterAssert(comparator != nil);

    return [array sortedArrayUsingComparator:comparator];
}

NSOrderedSet *__ASTSort_NSOrderedSet(NSOrderedSet *set) {
    return __ASTSort_NSOrderedSet_comparator(set, ASTCompare);
}

NSOrderedSet *__ASTSort_NSOrderedSet_comparator(NSOrderedSet *set, NSComparator comparator) {
    NSCParameterAssert(comparator != nil);

    if (set == nil) return nil;

    return [NSOrderedSet orderedSetWithArray:[set sortedArrayUsingComparator:comparator]];
}
