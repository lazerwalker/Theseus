//
//  ASTSort.h
//  Asterism
//
//  Created by Robert Böhnke on 25/03/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTSort) NSArray *__ASTSort_NSArray(NSArray *array);
ASTERISM_USE_INSTEAD(ASTSort) NSArray *__ASTSort_NSArray_comparator(NSArray *array, NSComparator comparator);
ASTERISM_USE_INSTEAD(ASTSort) NSOrderedSet *__ASTSort_NSOrderedSet(NSOrderedSet *set);
ASTERISM_USE_INSTEAD(ASTSort) NSOrderedSet *__ASTSort_NSOrderedSet_comparator(NSOrderedSet *set, NSComparator comparator);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Sorts an array using `-compare:`.
//
// array - An array of elements.
//
// Returns a copy of `array`, sorted using `-compare:`.
ASTERISM_OVERLOADABLE NSArray *ASTSort(NSArray *array) {
    return __ASTSort_NSArray(array);
}

// Sorts an array using a custom comparator.
//
// array      - An array of elements.
// comparator - An NSComparator used to compare the values. This argument must
//              not be nil.
//
// Returns a copy of `array`, sorted using `comparator`.
ASTERISM_OVERLOADABLE NSArray *ASTSort(NSArray *array, NSComparator comparator) {
    return __ASTSort_NSArray_comparator(array, comparator);
}

// Sorts an ordered set using `-compare:`.
//
// set - An array of elements.
//
// Returns a copy of `set`, sorted using `-compare:`.
ASTERISM_OVERLOADABLE NSOrderedSet *ASTSort(NSOrderedSet *set) {
    return __ASTSort_NSOrderedSet(set);
}

// Sorts an ordered set using a custom comparator.
//
// set        - An ordered set of elements.
// comparator - An NSComparator used to compare the values. This argument must
//              not be nil.
//
// Returns a copy of `set`, sorted using `comparator`.
ASTERISM_OVERLOADABLE NSOrderedSet *ASTSort(NSOrderedSet *set, NSComparator comparator) {
    return __ASTSort_NSOrderedSet_comparator(set, comparator);
}

#pragma clang diagnostic pop
