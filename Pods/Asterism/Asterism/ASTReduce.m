//
//  ASTReduce.m
//  Asterism
//
//  Created by Robert Böhnke on 5/26/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTReduce.h"

id __ASTReduce_NSDictionary_block(NSDictionary *dict, id(^block)(id memo, id obj)) {
    return ASTReduce(dict.allValues, block);
}

id __ASTReduce_NSDictionary_memo_block(NSDictionary *dict, id memo, id(^block)(id memo, id obj)) {
    return ASTReduce(dict.allValues, memo, block);
}

id __ASTReduce_NSFastEnumeration_block(id<NSFastEnumeration> collection, id(^block)(id memo, id obj)) {
    NSCParameterAssert(block != nil);

    id current;

    BOOL firstRun = YES;
    for (id obj in collection) {
        if (firstRun) {
            current = obj;
            firstRun = NO;
            continue;
        }

        current = block(current, obj);
    }

    return current;
}

id __ASTReduce_NSFastEnumeration_memo_block(id<NSFastEnumeration> collection, id memo, id(^block)(id memo, id obj)) {
    NSCParameterAssert(block != nil);

    id current = memo;

    for (id obj in collection) {
        current = block(current, obj);
    }

    return current;
}
