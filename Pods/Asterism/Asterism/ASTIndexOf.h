//
//  ASTIndexOf.h
//  Asterism
//
//  Created by Robert Böhnke on 24/11/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTIndexOf) NSUInteger __ASTIndexOf_NSArray(NSArray *array, id obj);
ASTERISM_USE_INSTEAD(ASTIndexOf) NSUInteger __ASTIndexOf_NSOrderedSet(NSOrderedSet *set, id obj);
ASTERISM_USE_INSTEAD(ASTIndexOf) NSUInteger __ASTIndexOf_NSFastEnumeration(id<NSFastEnumeration> collection, id obj);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Finds the index of an object in an array.
//
// array - An array of elements.
// obj   - The object to find.
//
// Returns the first index of obj in array or NSNotFound if the object could not
// be found.
ASTERISM_OVERLOADABLE NSUInteger ASTIndexOf(NSArray *array, id obj) {
    return __ASTIndexOf_NSArray(array, obj);
}

// Finds the index of an object in an ordered set.
//
// set - An ordered set of elements.
// obj - The object to find.
//
// Returns the first index of obj in set or NSNotFound if the object could not
// be found.
ASTERISM_OVERLOADABLE NSUInteger ASTIndexOf(NSOrderedSet *set, id obj) {
    return __ASTIndexOf_NSOrderedSet(set, obj);
}

// Finds the index of an object in a collection.
//
// collection - A collection of elements.
// obj        - The object to find.
//
// Returns the first index of obj in collection or NSNotFound if the object
// could not be found. If collection does not make a guarantee regarding its
// order, such as NSSet or NSDictionary, the meaning of the return value is
// undefined.
ASTERISM_OVERLOADABLE NSUInteger ASTIndexOf(id<NSFastEnumeration> collection, id obj) {
    return __ASTIndexOf_NSFastEnumeration(collection, obj);
}

#pragma clang diagnostic pop
