//
//  ASTEach.m
//  Asterism
//
//  Created by Robert Böhnke on 4/19/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTEach.h"

void __ASTEach_NSArray(NSArray *array, void(^iterator)(id)) {
    NSCParameterAssert(iterator != nil);

    ASTEach((id<NSFastEnumeration>)array, iterator);
}

void __ASTEach_NSArray_withIndex(NSArray *array, void(^iterator)(id, NSUInteger)) {
    NSCParameterAssert(iterator != nil);

    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        iterator(obj, idx);
    }];
}

void __ASTEach_NSDictionary(NSDictionary *dict, void(^iterator)(id obj)) {
    NSCParameterAssert(iterator != nil);

    ASTEach(dict, ^(id key, id obj) {
        iterator(obj);
    });
}

void __ASTEach_NSDictionary_keysAndValues(NSDictionary *dict, void(^iterator)(id key, id obj)) {
    NSCParameterAssert(iterator != nil);

    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        iterator(key, obj);
    }];
}

void __ASTEach_NSOrderedSet_withIndex(NSOrderedSet *set, void(^iterator)(id, NSUInteger)) {
    NSCParameterAssert(iterator != nil);

    [set enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        iterator(obj, idx);
    }];
}

void __ASTEach_NSFastEnumeration(id<NSFastEnumeration> enumerable, void(^iterator)(id obj)) {
    NSCParameterAssert(iterator != nil);

    for (id obj in enumerable) {
        iterator(obj);
    }
}
