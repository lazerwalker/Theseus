//
//  ASTFlatten.m
//  Asterism
//
//  Created by Felix-Johannes Jendrusch on 11/24/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTFlatten.h"

NSArray *__ASTFlatten_NSArray(NSArray *array) {
    NSMutableArray *result = [NSMutableArray array];

    for (NSArray *element in array) {
        if ([element isKindOfClass:[NSArray class]]) {
            [result addObjectsFromArray:element];
        } else {
            [result addObject:element];
        }
    }

    return result;
}
