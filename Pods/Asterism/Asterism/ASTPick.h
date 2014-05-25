//
//  ASTPick.h
//  Asterism
//
//  Created by Robert Böhnke on 31/12/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTPick) NSDictionary *__ASTPick_NSDictionary(NSDictionary *dict, NSArray *keys);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Picks the elements of a dictionary that are contained in a given array.
//
// dict - A dictionary of elements.
// keys - An array of keys to pick.
//
// Returns a dictionary of the keys and values in `dict` for which the keys are
// contained in `keys`.
ASTERISM_OVERLOADABLE NSDictionary *ASTPick(NSDictionary *dict, NSArray *keys) {
    return __ASTPick_NSDictionary(dict, keys);
}

#pragma clang diagnostic pop
