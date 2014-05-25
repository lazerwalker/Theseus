//
//  ASTUnion.h
//  Asterism
//
//  Created by Robert Böhnke on 6/18/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTUnion) NSArray *__ASTUnion_NSArray(NSArray *array, NSArray *other);
ASTERISM_USE_INSTEAD(ASTUnion) NSSet *__ASTUnion_NSSet(NSSet *set, NSSet *other);
ASTERISM_USE_INSTEAD(ASTUnion) NSOrderedSet *__ASTUnion_NSOrderedSet(NSOrderedSet *set, NSOrderedSet *other);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Returns the union of two arrays.
//
// array - An array of elements.
// other - An array of elements.
//
// Returns an array containing all elements of `array`, concatenated with all
// elements of `other` not already present in `array`. The order is being
// maintained.
ASTERISM_OVERLOADABLE NSArray *ASTUnion(NSArray *array, NSArray *other) {
    return __ASTUnion_NSArray(array, other);
}

// Returns the union two sets.
//
// set   - A set of elements.
// other - A set of elements.
//
// Returns a set containing the elements of `set` and `other`.
ASTERISM_OVERLOADABLE NSSet *ASTUnion(NSSet *set, NSSet *other) {
    return __ASTUnion_NSSet(set, other);
}

// Returns the union of two ordered sets.
//
// set   - An orderd set of elements.
// other - An orderd set of elements.
//
// Returns an orderd set containing all elements of `set`, concatenated with all
// elements of `other` not already present in `set`. The order is being
// maintained.
ASTERISM_OVERLOADABLE NSOrderedSet *ASTUnion(NSOrderedSet *set, NSOrderedSet *other) {
    return __ASTUnion_NSOrderedSet(set, other);
}

#pragma clang diagnostic pop
