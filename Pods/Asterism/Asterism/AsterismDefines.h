//
//  AsterismDefines.h
//  Asterism
//
//  Created by Robert Böhnke on 13/03/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

#define ASTERISM_OVERLOADABLE static inline __attribute__((overloadable))

#define ASTERISM_USE_INSTEAD(METHOD) __attribute__((deprecated("Don't call this method directly. You should use " # METHOD " instead.")))
