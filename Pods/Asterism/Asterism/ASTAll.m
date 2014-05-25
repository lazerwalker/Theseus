//
//  ASTAll.m
//  Asterism
//
//  Created by Robert Böhnke on 01/12/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTAll.h"

BOOL __ASTAll_NSDictionary(NSDictionary *dict, BOOL(^block)(id obj)) {
    return ASTAll(dict.allValues, block);
}

BOOL __ASTAll_NSFastEnumeration(id<NSFastEnumeration> collection, BOOL(^block)(id)) {
    NSCParameterAssert(block != nil);

    BOOL didTest = NO;

    for (id obj in collection) {
        if (!block(obj)) return NO;

        didTest = YES;
    }

    return didTest;
}
