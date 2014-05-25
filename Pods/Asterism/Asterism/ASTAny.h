//
//  ASTAny.h
//  Asterism
//
//  Created by Robert Böhnke on 01/12/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTAny) BOOL __ASTAny_NSDictionary(NSDictionary *dict, BOOL(^block)(id obj));
ASTERISM_USE_INSTEAD(ASTAny) BOOL __ASTAny_NSFastEnumeration(id<NSFastEnumeration> collection, BOOL(^block)(id obj));

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Tests if any value in a dictionary passes a test.
//
// dict  - A dictionary of elements.
// block - A block that takes a value of `dict` as its only argument and returns
//         `YES` if the value passes the test. The block must no be nil.
//
// Returns `YES` if any of the values in `dict` passes the test `block`.
ASTERISM_OVERLOADABLE BOOL ASTAny(NSDictionary *dict, BOOL(^block)(id obj)) {
    return __ASTAny_NSDictionary(dict, block);
}

// Tests if any element in a collection passes a test.
//
// collection - A collection of elements.
// block      - A block that takes an element as its only argument and returns
//              `YES` if the element passes the test. The block must no be nil.
//
// Returns `YES` if any of the elements in `collection` passes the test `block`.
ASTERISM_OVERLOADABLE BOOL ASTAny(id<NSFastEnumeration> collection, BOOL(^block)(id obj)) {
    return __ASTAny_NSFastEnumeration(collection, block);
}

#pragma clang diagnostic pop
