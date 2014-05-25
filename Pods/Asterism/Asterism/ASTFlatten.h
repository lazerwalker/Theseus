//
//  ASTFlatten.h
//  Asterism
//
//  Created by Felix-Johannes Jendrusch on 11/24/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTFlatten) NSArray *__ASTFlatten_NSArray(NSArray *array);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Flattens an array a single level.
//
// array - An array of elements.
//
// Returns a new array that concatenates all array elements in `array` while
// preserving non-array elements.
ASTERISM_OVERLOADABLE NSArray *ASTFlatten(NSArray *array) {
    return __ASTFlatten_NSArray(array);
}

#pragma clang diagnostic pop
