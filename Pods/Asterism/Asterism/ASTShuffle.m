//
//  ASTShuffle.m
//  Asterism
//
//  Created by Robert Böhnke on 11/02/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

#import "ASTShuffle.h"

NSArray *__ASTShuffle_NSArray(NSArray *array) {
    NSMutableArray *result = [array mutableCopy];

    for (NSInteger i = result.count - 1; i > 0; i--) {
        [result exchangeObjectAtIndex:arc4random_uniform((u_int32_t)i + 1)
                    withObjectAtIndex:i];
    }

    return result;
}

NSOrderedSet *__ASTShuffle_NSOrderedSet(NSOrderedSet *set) {
    NSMutableOrderedSet *result = [set mutableCopy];

    for (NSInteger i = result.count - 1; i > 0; i--) {
        [result exchangeObjectAtIndex:arc4random_uniform((u_int32_t)i + 1)
                    withObjectAtIndex:i];
    }

    return result;
}
