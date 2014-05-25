//
//  ASTMap.m
//  Asterism
//
//  Created by Robert Böhnke on 5/22/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTEach.h"

#import "ASTMap.h"

#pragma mark - Arrays

NSArray *__ASTMap_NSArray(NSArray *array, id(^block)(id obj)) {
    NSCParameterAssert(block != nil);

    if (array == nil) return nil;

    return ASTMap(array, ^(id obj, NSUInteger _) {
        return block(obj);
    });
}

NSArray *__ASTMap_NSArray_withIndex(NSArray *array, id(^block)(id obj, NSUInteger idx)) {
    NSCParameterAssert(block != nil);

    if (array == nil) return nil;

    NSMutableArray *result = [NSMutableArray array];

    ASTEach(array, ^(id obj, NSUInteger idx) {
        id transformed = block(obj, idx);

        if (transformed != nil) {
            [result addObject:transformed];
        }
    });

    return result;
}

NSDictionary *__ASTMap_NSDictionary(NSDictionary *dict, id(^block)(id obj)) {
    NSCParameterAssert(block != nil);

    if (dict == nil) return nil;

    return ASTMap(dict, ^(id _, id obj) {
        return block(obj);
    });
}

NSDictionary *__ASTMap_NSDictionary_keysAndValues(NSDictionary *dict, id(^block)(id key, id obj)) {
    NSCParameterAssert(block != nil);

    if (dict == nil) return nil;

    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    ASTEach(dict, ^(id key, id obj) {
        id transformed = block(key, obj);

        if (transformed != nil) {
            result[key] = transformed;
        }
    });

    return result;
}

NSSet *__ASTMap_NSSet(NSSet *set, id(^block)(id obj)) {
    NSCParameterAssert(block != nil);

    if (set == nil) return nil;

    NSMutableSet *result = [NSMutableSet set];

    ASTEach(set, ^(id obj) {
        id transformed = block(obj);

        if (transformed != nil) {
            [result addObject:transformed];
        }
    });

    return result;
}

NSOrderedSet *__ASTMap_NSOrderedSet(NSOrderedSet *set, id(^block)(id obj)) {
    NSCParameterAssert(block != nil);

    if (set == nil) return nil;

    return ASTMap(set, ^(id obj, NSUInteger _) {
        return block(obj);
    });
}

NSOrderedSet *__ASTMap_NSOrderedSet_withIndex(NSOrderedSet *set, id(^block)(id obj, NSUInteger idx)) {
    NSCParameterAssert(block != nil);

    if (set == nil) return nil;

    NSMutableOrderedSet *result = [NSMutableOrderedSet orderedSet];

    ASTEach(set, ^(id obj, NSUInteger idx) {
        id transformed = block(obj, idx);

        if (transformed != nil) {
            [result addObject:transformed];
        }
    });

    return result;
}
