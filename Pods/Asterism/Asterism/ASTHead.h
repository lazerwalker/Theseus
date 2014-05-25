//
//  ASTHead.h
//  Asterism
//
//  Created by Robert Böhnke on 6/1/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTHead) id __ASTHead_NSArray(NSArray *array);
ASTERISM_USE_INSTEAD(ASTHead) id __ASTHead_NSOrderedSet(NSOrderedSet *set);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Returns the first element of an array.
//
// array - An array of elements.
//
// Returns the first element or `nil` if the array is empty.
ASTERISM_OVERLOADABLE id ASTHead(NSArray *array) {
    return __ASTHead_NSArray(array);
}

// Returns the first element of an ordered set.
//
// set - An ordered set of elements.
//
// Returns the first element or `nil` if the ordered set is empty.
ASTERISM_OVERLOADABLE id ASTHead(NSOrderedSet *set) {
    return __ASTHead_NSOrderedSet(set);
}

#pragma clang diagnostic pop
