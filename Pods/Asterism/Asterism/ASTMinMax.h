//
//  ASTMinMax.h
//  Asterism
//
//  Created by Robert Böhnke on 6/4/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTMin) id __ASTMin_NSDictionary(NSDictionary *dict);
ASTERISM_USE_INSTEAD(ASTMin) id __ASTMin_NSDictionary_comparator(NSDictionary *dict, NSComparator comparator);
ASTERISM_USE_INSTEAD(ASTMax) id __ASTMax_NSDictionary(NSDictionary *dict);
ASTERISM_USE_INSTEAD(ASTMax) id __ASTMax_NSDictionary_comparator(NSDictionary *dict, NSComparator comparator);
ASTERISM_USE_INSTEAD(ASTMin) id __ASTMin_NSFastEnumeration(id<NSFastEnumeration> collection);
ASTERISM_USE_INSTEAD(ASTMin) id __ASTMin_NSFastEnumeration_comparator(id<NSFastEnumeration> collection, NSComparator comparator);
ASTERISM_USE_INSTEAD(ASTMax) id __ASTMax_NSFastEnumeration(id<NSFastEnumeration> collection);
ASTERISM_USE_INSTEAD(ASTMax) id __ASTMax_NSFastEnumeration_comparator(id<NSFastEnumeration> collection, NSComparator comparator);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Returns the minimum of the values of a dictionary by invoking -compare:.
//
// dict - A dictionary of elements.
//
// Returns the minimum of the values of `dict` comparing all values by invoking
// -compare:.
ASTERISM_OVERLOADABLE id ASTMin(NSDictionary *dict) {
    return __ASTMin_NSDictionary(dict);
}

// Returns the minimum of the values of a dictionary by using an NSComparator.
//
// dict       - A dictionary of elements.
// comparator - An NSComparator used to compare the values.
//              This argument must not be nil.
//
// Returns the minimum of the values of `dict` comparing all values using
// `comparator`.
ASTERISM_OVERLOADABLE id ASTMin(NSDictionary *dict, NSComparator comparator) {
    return __ASTMin_NSDictionary_comparator(dict, comparator);
}

// Returns the maximum of the values of a dictionary by invoking -compare:.
//
// dict - A dictionary of elements.
//
// Returns the maximum of the values of `dict` comparing all values by invoking
// -compare:.
ASTERISM_OVERLOADABLE id ASTMax(NSDictionary *dict) {
    return __ASTMax_NSDictionary(dict);
}

// Returns the maximum of the values of a dictionary by using an NSComparator.
//
// dict       - A dictionary of elements.
// comparator - An NSComparator used to compare the values.
//              This argument must not be nil.
//
// Returns the maximum of the values of `dict` comparing all values using
// `comparator`.
ASTERISM_OVERLOADABLE id ASTMax(NSDictionary *dict, NSComparator comparator) {
    return __ASTMax_NSDictionary_comparator(dict, comparator);
}

// Returns the minimum of a collection by invoking -compare:.
//
// collection - An object that implements NSFastEnumeration.
//
// Returns the minimum of the collection by comparing all values by invoking
// -compare:.
ASTERISM_OVERLOADABLE id ASTMin(id<NSFastEnumeration> collection) {
    return __ASTMin_NSFastEnumeration(collection);
}

// Returns the minimum of a collection by using an NSComparator.
//
// collection - An object that implements NSFastEnumeration.
// comparator - An NSComparator used to compare the values.
//              This argument must not be nil.
//
// Returns the minimum of the collection by comparing all values using
// `comparator`.
ASTERISM_OVERLOADABLE id ASTMin(id<NSFastEnumeration> collection, NSComparator comparator) {
    return __ASTMin_NSFastEnumeration_comparator(collection, comparator);
}

// Returns the maximum of a collection by invoking -compare:.
//
// collection - An object that implements NSFastEnumeration.
//
// Returns the maximum of the collection by comparing all values by invoking
// -compare:.
ASTERISM_OVERLOADABLE id ASTMax(id<NSFastEnumeration> collection) {
    return __ASTMax_NSFastEnumeration(collection);
}

// Returns the maximum of a collection by using an NSComparator.
//
// collection - An object that implements NSFastEnumeration.
// comparator - An NSComparator used to compare the values.
//              This argument must not be nil.
//
// Returns the maximum of the collection by comparing all values using
// `comparator`.
ASTERISM_OVERLOADABLE id ASTMax(id<NSFastEnumeration> collection, NSComparator comparator) {
    return __ASTMax_NSFastEnumeration_comparator(collection, comparator);
}

#pragma clang diagnostic pop
