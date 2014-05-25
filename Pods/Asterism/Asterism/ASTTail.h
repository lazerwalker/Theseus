//
//  ASTTail.h
//  Asterism
//
//  Created by Robert Böhnke on 6/1/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTTail) NSArray *__ASTTail_NSArray(NSArray *array);
ASTERISM_USE_INSTEAD(ASTTail) NSOrderedSet *__ASTTail_NSOrderedSet(NSOrderedSet *set);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Returns all elements of an array after the first one.
//
// array - An array of elements.
//
// Returns all elements after the first one. If the array has less than one
// element, an empty array is returned.
ASTERISM_OVERLOADABLE NSArray *ASTTail(NSArray *array) {
    return __ASTTail_NSArray(array);
}

// Returns all elements of an ordered set after the first one.
//
// set - An ordered set of elements.
//
// Returns all elements after the first one. If the set has less than one
// element, an empty ordered set is returned.
ASTERISM_OVERLOADABLE NSOrderedSet *ASTTail(NSOrderedSet *set) {
    return __ASTTail_NSOrderedSet(set);
}

#pragma clang diagnostic pop
