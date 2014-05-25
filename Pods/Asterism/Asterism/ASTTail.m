//
//  ASTTail.m
//  Asterism
//
//  Created by Robert Böhnke on 6/1/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTTail.h"

NSArray *__ASTTail_NSArray(NSArray *array) {
    if (array == nil) return nil;

    if (array.count <= 1) return @[];

    NSRange range = NSMakeRange(1, array.count - 1);

    return [array subarrayWithRange:range];
}

NSOrderedSet *__ASTTail_NSOrderedSet(NSOrderedSet *set) {
    if (set == nil) return nil;

    if (set.count <= 1) return [NSOrderedSet orderedSet];

    NSRange range = NSMakeRange(1, set.count - 1);

    return [NSOrderedSet orderedSetWithArray:[set.array subarrayWithRange:range]];
}
