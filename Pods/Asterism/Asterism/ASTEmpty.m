//
//  ASTEmpty.m
//  Asterism
//
//  Created by Robert Böhnke on 8/5/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTEmpty.h"

BOOL __ASTEmpty_NSArray(NSArray *array) {
    return array.count == 0;
}

BOOL __ASTEmpty_NSDictionary(NSDictionary *dictionary) {
    return dictionary.count == 0;
}

BOOL __ASTEmpty_NSSet(NSSet *set) {
    return set.count == 0;
}

BOOL __ASTEmpty_NSOrderedSet(NSOrderedSet *set) {
    return set.count == 0;
}

BOOL __ASTEmpty_NSFastEnumeration(id<NSFastEnumeration> collection) {
    for (__attribute__((unused)) id _ in collection) return NO;

    return YES;
}
