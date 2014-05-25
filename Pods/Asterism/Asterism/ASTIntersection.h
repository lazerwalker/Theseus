//
//  ASTIntersection.h
//  Asterism
//
//  Created by Robert Böhnke on 6/18/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTIntersection) NSArray *__ASTIntersection_NSArray(NSArray *array, NSArray *other);
ASTERISM_USE_INSTEAD(ASTIntersection) NSSet *__ASTIntersection_NSSet(NSSet *set, NSSet *other);
ASTERISM_USE_INSTEAD(ASTIntersection) NSOrderedSet *__ASTIntersection_NSOrderedSet(NSOrderedSet *set, NSOrderedSet *other);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Returns the intersection of two arrays.
//
// array - An array of elements.
// other - An array of elements.
//
// Returns an array containing the elements of `array` that are also present in
// `other`. The order is being maintained.
ASTERISM_OVERLOADABLE NSArray *ASTIntersection(NSArray *array, NSArray *other) {
    return __ASTIntersection_NSArray(array, other);
}

// Returns the difference between two sets.
//
// set   - A set of elements.
// other - A set of elements.
//
// Returns a set containing the elements of `set` that are also present in
// `other`.
ASTERISM_OVERLOADABLE NSSet *ASTIntersection(NSSet *set, NSSet *other) {
    return __ASTIntersection_NSSet(set, other);
}

// Returns the difference between two ordered sets.
//
// set   - An ordered set of elements.
// other - An ordered set of elements.
//
// Returns a set containing the elements of `set` that are also present in
// `other`. The order is being maintained.
ASTERISM_OVERLOADABLE NSOrderedSet *ASTIntersection(NSOrderedSet *set, NSOrderedSet *other) {
    return __ASTIntersection_NSOrderedSet(set, other);
}

#pragma clang diagnostic pop
