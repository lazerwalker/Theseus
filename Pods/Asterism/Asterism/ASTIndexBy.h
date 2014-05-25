//
//  ASTIndexBy.h
//  Asterism
//
//  Created by Robert Böhnke on 14/12/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTIndexBy) NSDictionary *__ASTIndexBy_NSDictionary_block(NSDictionary *dict, id<NSCopying> (^block)(id obj));
ASTERISM_USE_INSTEAD(ASTIndexBy) NSDictionary *__ASTIndexBy_NSDictionary_keyPath(NSDictionary *dict, NSString *keyPath);
ASTERISM_USE_INSTEAD(ASTIndexBy) NSDictionary *__ASTIndexBy_NSFastEnumeration_block(id<NSFastEnumeration> collection, id<NSCopying> (^block)(id obj));
ASTERISM_USE_INSTEAD(ASTIndexBy) NSDictionary *__ASTIndexBy_NSFastEnumeration_keyPath(id<NSFastEnumeration> collection, NSString *keyPath);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Indexes the values of a dictionary using a block.
//
// dict  - A dictionary of elements.
// block - A block that takes a value of `dict` as its only argument and returns
//         a key by which to index the element.
//         The return value is required to implement NSCopying.
//         The block must not be nil.
//
// Returns a dictionary that maps the keys returned by `block` to the respective
// input value. If `block` returns the same value for multiple values, an
// arbitrary value is chosen.
ASTERISM_OVERLOADABLE NSDictionary *ASTIndexBy(NSDictionary *dict, id<NSCopying> (^block)(id obj)) {
    return __ASTIndexBy_NSDictionary_block(dict, block);
}

// Indexes the values of a dictionary by their value for a given key path.
//
// dict     - A dictionary of elements.
// key path - A key path for which the values of `dict` return either an object
//            that implements NSCopying or nil.
//            This parameter must not be nil.
//
// Returns a dictionary that maps the values the elements return for `keyPath`
// to the respective input value. If multiple values return the same value for
// `keyPath`, an arbitrary element is chosen.
ASTERISM_OVERLOADABLE NSDictionary *ASTIndexBy(NSDictionary *dict, NSString *keyPath) {
    return __ASTIndexBy_NSDictionary_keyPath(dict, keyPath);
}

// Indexes the elements of a collection using a block.
//
// collection - An object that implements NSFastEnumeration.
// block      - A block that takes an element in `collection` as its only
//              argument and returns a key by which to index the element.
//              The return value is required to implement NSCopying.
//              The block must not be nil.
//
// Returns a dictionary that maps the keys returned by `block` to the respective
// input value. If `block` returns the same value for multiple values, an
// arbitrary value is chosen.
//
// Examples
//
//     NSArray *strings = @[ @"foo", @"bar" ];
//
//     NSDictionary *indexed = ASTIndexBy(strings, ^(NSString *string){
//         return @([string characterAtIndex:0]);
//     });
//
//     indexed[@"f"]; // @"foo"
//     indexed[@"b"]; // @"bar"
//
ASTERISM_OVERLOADABLE NSDictionary *ASTIndexBy(id<NSFastEnumeration> collection, id<NSCopying> (^block)(id obj)) {
    return __ASTIndexBy_NSFastEnumeration_block(collection, block);
}

// Indexes the elements in a collection by their value for a given key path.
//
// collection - An object that implements NSFastEnumeration.
// key path   - A key path for which the elements in `collection` return either
//              an object that implements NSCopying or nil.
//              This parameter must not be nil.
//
// Returns a dictionary that maps the values the elements return for `keyPath`
// to the respective input value. If multiple values return the same value for
// `keyPath`, an arbitrary element is chosen.
//
// Examples
//
//     NSArray *strings = @[ @"a", @"ab", @"abc" ];
//
//     NSDictionary *indexed = ASTIndexBy(strings, @"length");
//
//     indexed[@1]; // @"a"
//     indexed[@2]; // @"ab"
//     indexed[@3]; // @"abc"
//
ASTERISM_OVERLOADABLE NSDictionary *ASTIndexBy(id<NSFastEnumeration> collection, NSString *keyPath) {
    return __ASTIndexBy_NSFastEnumeration_keyPath(collection, keyPath);
}

#pragma clang diagnostic pop
