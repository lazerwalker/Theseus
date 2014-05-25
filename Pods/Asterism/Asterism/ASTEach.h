//
//  ASTEach.h
//  Asterism
//
//  Created by Robert Böhnke on 4/19/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTEach) void __ASTEach_NSArray(NSArray *array, void(^iterator)(id obj));
ASTERISM_USE_INSTEAD(ASTEach) void __ASTEach_NSArray_withIndex(NSArray *array, void(^iterator)(id obj, NSUInteger idx));
ASTERISM_USE_INSTEAD(ASTEach) void __ASTEach_NSDictionary(NSDictionary *dict, void(^iterator)(id obj));
ASTERISM_USE_INSTEAD(ASTEach) void __ASTEach_NSDictionary_keysAndValues(NSDictionary *dict, void(^iterator)(id key, id obj));
ASTERISM_USE_INSTEAD(ASTEach) void __ASTEach_NSOrderedSet_withIndex(NSOrderedSet *set, void(^iterator)(id obj, NSUInteger idx));
ASTERISM_USE_INSTEAD(ASTEach) void __ASTEach_NSFastEnumeration(id<NSFastEnumeration> enumerable, void(^iterator)(id obj));

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Iterates over all elements of an array.
//
// array    - An array of elements.
// iterator - A block that takes an element as its only argument. The block must
//            not be nil.
ASTERISM_OVERLOADABLE void ASTEach(NSArray *array, void(^iterator)(id obj)) {
    __ASTEach_NSArray(array, iterator);
}

// Iterates over all elements of an array, as well as their indexes.
//
// array    - An array of elements.
// iterator - A block that takes an element and its index in `array` as its
//            arguments. The block must not be nil.
ASTERISM_OVERLOADABLE void ASTEach(NSArray *array, void(^iterator)(id obj, NSUInteger idx)) {
    __ASTEach_NSArray_withIndex(array, iterator);
}

// Iterates over all values of a dictionary.
//
// dict     - A dictionary of elements.
// iterator - A block that takes an element as its only argument. The block must
//            not be nil.
ASTERISM_OVERLOADABLE void ASTEach(NSDictionary *dict, void(^iterator)(id obj)) {
    __ASTEach_NSDictionary(dict, iterator);
}

// Iterates over all keys and values of a dictionary.
//
// dict     - A dictionary of elements.
// iterator - A block that takes a key and a value as its arguments. The block
//            must not be nil.
ASTERISM_OVERLOADABLE void ASTEach(NSDictionary *dict, void(^iterator)(id key, id obj)) {
    __ASTEach_NSDictionary_keysAndValues(dict, iterator);
}

// Iterates over all elements of an ordered set, as well as their indexes.
//
// set      - An ordered set of elements.
// iterator - A block that takes an element and its index in `set` as its
//            arguments. The block must not be nil.
ASTERISM_OVERLOADABLE void ASTEach(NSOrderedSet *set, void(^iterator)(id obj, NSUInteger idx)) {
    __ASTEach_NSOrderedSet_withIndex(set, iterator);
}

// Iterates over elements in a collection.
//
// enumerable - An object that implements NSFastEnumeration.
// iterator   - A block that takes an element as its only argument. The block
//              must not be nil.
ASTERISM_OVERLOADABLE void ASTEach(id<NSFastEnumeration> enumerable, void(^iterator)(id obj)) {
    __ASTEach_NSFastEnumeration(enumerable, iterator);
}

#pragma clang diagnostic pop
