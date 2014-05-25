//
//  ASTWithout.h
//  Asterism
//
//  Created by Robert Böhnke on 19/12/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTWithout) NSArray *__ASTWithout_NSArray(NSArray *array, id obj);
ASTERISM_USE_INSTEAD(ASTWithout) NSSet *__ASTWithout_NSSet(NSSet *set, id obj);
ASTERISM_USE_INSTEAD(ASTWithout) NSOrderedSet *__ASTWithout_NSOrderedSet(NSOrderedSet *set, id obj);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Filters out the elements of an array that are equal to a given value.
//
// array - An array of elements.
// obj   - An element to be removed.
//
// Returns an array of all values in `array` that are not equal to `obj`. The
// order is being maintained.
ASTERISM_OVERLOADABLE NSArray *ASTWithout(NSArray *array, id obj) {
    return __ASTWithout_NSArray(array, obj);
}

// Filters out the elements of a set that are equal to a given value.
//
// set - A set of elements.
// obj - An element to be removed.
//
// Returns a set of all values in `set` that are not equal to `obj`.
ASTERISM_OVERLOADABLE NSSet *ASTWithout(NSSet *set, id obj) {
    return __ASTWithout_NSSet(set, obj);
}

// Filters out the elements of an ordered set that are equal to a given value.
//
// set - An ordered set of elements.
// obj - An element to be removed.
//
// Returns an ordered set of all values in `set` that are not equal to `obj`.
// The order is being maintained.
ASTERISM_OVERLOADABLE NSOrderedSet *ASTWithout(NSOrderedSet *set, id obj) {
    return __ASTWithout_NSOrderedSet(set, obj);
}

#pragma clang diagnostic pop
