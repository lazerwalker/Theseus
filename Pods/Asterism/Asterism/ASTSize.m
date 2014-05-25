//
//  ASTSize.m
//  Asterism
//
//  Created by Robert Böhnke on 07/12/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTSize.h"

NSUInteger __ASTSize_NSArray(NSArray *array) {
    return array.count;
}

NSUInteger __ASTSize_NSDictionary(NSDictionary *dictionary) {
    return dictionary.count;
}

NSUInteger __ASTSize_NSSet(NSSet *set) {
    return set.count;
}

NSUInteger __ASTSize_NSOrderedSet(NSOrderedSet *set) {
    return set.count;
}

NSUInteger __ASTSize_NSFastEnumeration(id<NSFastEnumeration> collection) {
    NSUInteger size = 0;

    for (__attribute__((unused)) id _ in collection) size++;

    return size;
}
