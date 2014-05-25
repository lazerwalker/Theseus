//
//  ASTSize.h
//  Asterism
//
//  Created by Robert Böhnke on 07/12/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTSize) NSUInteger __ASTSize_NSArray(NSArray *array);
ASTERISM_USE_INSTEAD(ASTSize) NSUInteger __ASTSize_NSDictionary(NSDictionary *dictionary);
ASTERISM_USE_INSTEAD(ASTSize) NSUInteger __ASTSize_NSSet(NSSet *set);
ASTERISM_USE_INSTEAD(ASTSize) NSUInteger __ASTSize_NSOrderedSet(NSOrderedSet *set);
ASTERISM_USE_INSTEAD(ASTSize) NSUInteger __ASTSize_NSFastEnumeration(id<NSFastEnumeration> collection);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// The number of values in an array.
//
// array - An array of elements.
//
// Returns the size of `array`.
ASTERISM_OVERLOADABLE NSUInteger ASTSize(NSArray *array) {
    return __ASTSize_NSArray(array);
}

// The number of values in a dictionary.
//
// dictionary - A dictionary of elements.
//
// Returns the size of `dictionary`.
ASTERISM_OVERLOADABLE NSUInteger ASTSize(NSDictionary *dictionary) {
    return __ASTSize_NSDictionary(dictionary);
}

// The number of values in a set.
//
// set - A set of elements.
//
// Returns the size of `set`.
ASTERISM_OVERLOADABLE NSUInteger ASTSize(NSSet *set) {
    return __ASTSize_NSSet(set);
}

// The number of values in an ordered set.
//
// set - An ordered set of elements.
//
// Returns the size of `set`.
ASTERISM_OVERLOADABLE NSUInteger ASTSize(NSOrderedSet *set) {
    return __ASTSize_NSOrderedSet(set);
}

// Counts the number of elements in a collection.
//
// collection - A collection of elements.
//
// Returns the size of `collection` in O(n).
ASTERISM_OVERLOADABLE NSUInteger ASTSize(id<NSFastEnumeration> collection) {
    return __ASTSize_NSFastEnumeration(collection);
}

#pragma clang diagnostic pop
