//
//  ASTAny.m
//  Asterism
//
//  Created by Robert Böhnke on 01/12/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTAny.h"

BOOL __ASTAny_NSDictionary(NSDictionary *dict, BOOL(^block)(id obj)) {
    return ASTAny(dict.allValues, block);
}

BOOL __ASTAny_NSFastEnumeration(id<NSFastEnumeration> collection, BOOL(^block)(id)) {
    NSCParameterAssert(block != nil);

    for (id obj in collection) {
        if (block(obj)) return YES;
    }

    return NO;
}
