//
//  ASTReject.m
//  Asterism
//
//  Created by Robert Böhnke on 6/3/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTFilter.h"
#import "ASTNegate.h"

#import "ASTReject.h"

NSArray *__ASTReject_NSArray(NSArray *array, BOOL(^block)(id)) {
    NSCParameterAssert(block != nil);

    return ASTFilter(array, ASTNegate(block));
}

NSArray *__ASTReject_NSArray_withIndex(NSArray *array, BOOL(^block)(id, NSUInteger)) {
    NSCParameterAssert(block != nil);

    return ASTFilter(array, ASTNegate(block));
}

NSDictionary *__ASTReject_NSDictionary(NSDictionary *dict, BOOL(^block)(id)) {
    NSCParameterAssert(block != nil);

    return ASTFilter(dict, ASTNegate(block));
}

NSDictionary *__ASTReject_NSDictionary_keysAndValues(NSDictionary *dict, BOOL(^block)(id key, id obj)) {
    NSCParameterAssert(block != nil);

    return ASTFilter(dict, ASTNegate(block));
}

NSSet *__ASTReject_NSSet(NSSet *set, BOOL(^block)(id obj)) {
    NSCParameterAssert(block != nil);

    return ASTFilter(set, ASTNegate(block));
}

NSOrderedSet *__ASTReject_NSOrderedSet(NSOrderedSet *set, BOOL(^block)(id obj)) {
    NSCParameterAssert(block != nil);

    return ASTFilter(set, ASTNegate(block));
}

NSOrderedSet *__ASTReject_NSOrderedSet_withIndex(NSOrderedSet *set, BOOL(^block)(id obj, NSUInteger idx)) {
    NSCParameterAssert(block != nil);

    return ASTFilter(set, ASTNegate(block));
}
