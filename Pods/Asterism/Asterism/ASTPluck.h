//
//  ASTPluck.h
//  Asterism
//
//  Created by Robert Böhnke on 6/3/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTPluck) NSDictionary *__ASTPluck_NSDictionary(NSDictionary *dict, NSString *keyPath);
ASTERISM_USE_INSTEAD(ASTPluck) NSArray *__ASTPluck_NSFastEnumeration(id<NSFastEnumeration> collection, NSString *keyPath);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Extracts a value for a given key path from all values of a dictionary.
//
// dict    - A dictionary of elements.
// keyPath - A key path. This argument must not be nil.
//
// Returns a dictionary mapping the original keys to the values that the
// values in `dict` return for `keyPath`. If a value returns nil when invoked
// with -valueForKeyPath:, it is not present in the returned dictionary.
ASTERISM_OVERLOADABLE NSDictionary *ASTPluck(NSDictionary *dictionary, NSString *keyPath) {
    return __ASTPluck_NSDictionary(dictionary, keyPath);
}

// Extracts a value for a given key path from all elements in a collection.
//
// collection - An object that implements NSFastEnumeration.
// keyPath    - A key path. This argument must not be nil.
//
// Returns an array of the values that the elements in `collection` return for
// `keyPath`. If an element returns nil when invoked with -valueForKeyPath:,
// it is not present in the returned array. If possible, the order is being
// maintained.
ASTERISM_OVERLOADABLE NSArray *ASTPluck(id<NSFastEnumeration> collection, NSString *keyPath) {
    return __ASTPluck_NSFastEnumeration(collection, keyPath);
}

#pragma clang diagnostic pop
