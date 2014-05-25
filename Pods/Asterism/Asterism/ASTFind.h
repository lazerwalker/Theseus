//
//  ASTFind.h
//  Asterism
//
//  Created by Robert Böhnke on 6/23/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTFind) id __ASTFind_NSArray(NSArray *array, BOOL(^block)(id obj));
ASTERISM_USE_INSTEAD(ASTFind) id __ASTFind_NSArray_withIndex(NSArray *array, BOOL(^block)(id obj, NSUInteger idx));
ASTERISM_USE_INSTEAD(ASTFind) id __ASTFind_NSDictionary(NSDictionary *dict, BOOL(^block)(id obj));
ASTERISM_USE_INSTEAD(ASTFind) id __ASTFind_NSDictionary_keysAndValues(NSDictionary *dict, BOOL(^block)(id key, id obj));
ASTERISM_USE_INSTEAD(ASTFind) id __ASTFind_NSFastEnumeration(id<NSFastEnumeration> collection, BOOL(^block)(id obj));

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Finds an element in an array.
//
// array - An array of elements.
// block - A block that takes an element as its only argument and returns `YES`
//         if it matches the search criteria. The block must not be nil.
//
// Returns the first item in `array` for which `block` returns `YES` or `nil` if
// no such value was found.
ASTERISM_OVERLOADABLE id ASTFind(NSArray *array, BOOL(^block)(id obj)) {
    return __ASTFind_NSArray(array, block);
}

// Finds an element in an array.
//
// array - An array of elements.
// block - A block that takes an element and its index in `array` as its
//         arguments and returns `YES` if this is they match the search
//         criteria. The block must not be nil.
//
// Returns the first item in `array` for which `block` returns `YES` or `nil` if
// no such value was found.
ASTERISM_OVERLOADABLE id ASTFind(NSArray *array, BOOL(^block)(id obj, NSUInteger idx)) {
    return __ASTFind_NSArray_withIndex(array, block);
}

// Finds a value in a dictionary.
//
// dict  - A dictionary of elements.
// block - A block that takes a value as its argument and returns `YES` if it
//         matches the search criteria. The block must not be nil.
//
// Returns any value in `dict` for which `block` returns `YES` or `nil` if no
// such value was found.
ASTERISM_OVERLOADABLE id ASTFind(NSDictionary *dict, BOOL(^block)(id obj)) {
    return __ASTFind_NSDictionary(dict, block);
}

// Finds a value in a dictionary.
//
// dict  - A dictionary of elements.
// block - A block that takes a key and its value as its arguments and returns
//         `YES` if they match the search criteria. The block must not be nil.
//
// Returns any value in `dict` for which `block` returns `YES` or `nil` if no
// such value was found.
ASTERISM_OVERLOADABLE id ASTFind(NSDictionary *dict, BOOL(^block)(id key, id obj)) {
    return __ASTFind_NSDictionary_keysAndValues(dict, block);
}

// Finds a value in a collection.
//
// collection - An object that implements NSFastEnumeration.
// block      - A block that takes an element as its only argument and returns
//              `YES` if it matches the search criteria. The block must not be
//              nil.
//
// Returns a value in `collection` for which `block` returns `YES` or `nil` if
// no such value was found. If `collection` makes an order guarantee, `ASTFind`
// will return the first value matching the search criteria.
ASTERISM_OVERLOADABLE id ASTFind(id<NSFastEnumeration> collection, BOOL(^block)(id obj)) {
    return __ASTFind_NSFastEnumeration(collection, block);
}

#pragma clang diagnostic pop
