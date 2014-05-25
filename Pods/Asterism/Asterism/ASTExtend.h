//
//  ASTExtend.h
//  Asterism
//
//  Created by Robert Böhnke on 24/11/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsterismDefines.h"

// You should not call these methods directly.
ASTERISM_USE_INSTEAD(ASTExtend) NSDictionary *__ASTExtend_NSDictionary(NSDictionary *dict, NSDictionary *source);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// Extends a dictionary with values from another dictionary.
//
// dict   - A dictionary.
// source - A dictionary of extensions.
//
// Returns a new dictionary that contains a union of key-value-pairs of `dict`
// and `source`. Key-value-pairs of `source` will have precedence over those
// taken from `dict`.
ASTERISM_OVERLOADABLE NSDictionary *ASTExtend(NSDictionary *dict, NSDictionary *source) {
    return __ASTExtend_NSDictionary(dict, source);
}

#pragma clang diagnostic pop
