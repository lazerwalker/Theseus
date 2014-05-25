//
//  ASTFind.m
//  Asterism
//
//  Created by Robert Böhnke on 6/23/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTFind.h"

id __ASTFind_NSArray(NSArray *array, BOOL(^block)(id)) {
    NSCParameterAssert(block != nil);

    if (array == nil) return nil;

    NSUInteger index = [array indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }];

    return index == NSNotFound ? nil : array[index];
}

id __ASTFind_NSArray_withIndex(NSArray *array, BOOL(^block)(id, NSUInteger)) {
    NSCParameterAssert(block != nil);

    if (array == nil) return nil;

    NSUInteger index = [array indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj, idx);
    }];

    return index == NSNotFound ? nil : array[index];
}

id __ASTFind_NSDictionary(NSDictionary *dict, BOOL(^block)(id)) {
    NSCParameterAssert(block != nil);

    for (id key in dict) {
        id value = dict[key];

        if (block(value)) return value;
    }

    return nil;
}

id __ASTFind_NSDictionary_keysAndValues(NSDictionary *dict, BOOL(^block)(id, id)) {
    NSCParameterAssert(block != nil);

    for (id key in dict) {
        id value = dict[key];

        if (block(key, value)) return value;
    }

    return nil;
}

id __ASTFind_NSFastEnumeration(id<NSFastEnumeration> collection, BOOL(^block)(id obj)) {
    NSCParameterAssert(block != nil);

    for (id obj in collection) {
        if (block(obj)) return obj;
    }

    return nil;
}
