//
//  ASTFilter.m
//  Asterism
//
//  Created by Robert Böhnke on 6/1/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTFilter.h"

NSArray *__ASTFilter_NSArray(NSArray *array, BOOL(^block)(id)) {
    NSCParameterAssert(block != nil);

    NSIndexSet *indexes = [array indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }];

    return [array objectsAtIndexes:indexes];
}

NSArray *__ASTFilter_NSArray_withIndex(NSArray *array, BOOL(^block)(id, NSUInteger)) {
    NSCParameterAssert(block != nil);

    NSIndexSet *indexes = [array indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj, idx);
    }];

    return [array objectsAtIndexes:indexes];
}

NSDictionary *__ASTFilter_NSDictionary(NSDictionary *dict, BOOL(^block)(id)) {
    NSCParameterAssert(block != nil);

    NSSet *keys = [dict keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        return block(obj);
    }];

    return [dict dictionaryWithValuesForKeys:keys.allObjects];
}

NSDictionary *__ASTFilter_NSDictionary_keysAndValues(NSDictionary *dict, BOOL(^block)(id, id)) {
    NSCParameterAssert(block != nil);

    NSSet *keys = [dict keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        return block(key, obj);
    }];

    return [dict dictionaryWithValuesForKeys:keys.allObjects];
}

NSSet *__ASTFilter_NSSet(NSSet *set, BOOL(^block)(id)) {
    NSCParameterAssert(block != nil);

    return [set objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        return block(obj);
    }];
}

NSOrderedSet *__ASTFilter_NSOrderedSet(NSOrderedSet *set, BOOL(^block)(id)) {
    NSCParameterAssert(block != nil);

    NSIndexSet *indexes = [set indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }];

    return [NSOrderedSet orderedSetWithArray:[set objectsAtIndexes:indexes]];
}

NSOrderedSet *__ASTFilter_NSOrderedSet_withIndex(NSOrderedSet *set, BOOL(^block)(id, NSUInteger)) {
    NSCParameterAssert(block != nil);

    NSIndexSet *indexes = [set indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj, idx);
    }];

    return [NSOrderedSet orderedSetWithArray:[set objectsAtIndexes:indexes]];
}
