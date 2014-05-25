//
//  ASTPluck.m
//  Asterism
//
//  Created by Robert Böhnke on 6/3/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTMap.h"

#import "ASTPluck.h"

NSDictionary *__ASTPluck_NSDictionary(NSDictionary *dict, NSString *keyPath) {
    NSCParameterAssert(keyPath != nil);

    return ASTMap(dict, ^id(id obj) {
        return [obj valueForKeyPath:keyPath];
    });
}

NSArray *__ASTPluck_NSFastEnumeration(id<NSFastEnumeration> collection, NSString *keyPath) {
    NSCParameterAssert(keyPath != nil);

    if (collection == nil) return nil;

    NSMutableArray *result = [NSMutableArray array];

    for (id obj in collection) {
        id value = [obj valueForKeyPath:keyPath];

        if (value != nil) {
            [result addObject:value];
        }
    }

    return result;
}
