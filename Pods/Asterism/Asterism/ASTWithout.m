//
//  ASTWithout.m
//  Asterism
//
//  Created by Robert Böhnke on 19/12/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTReject.h"

#import "ASTWithout.h"

NSArray *__ASTWithout_NSArray(NSArray *collection, id obj) {
    return ASTReject(collection, ^BOOL(id other) {
        return [obj isEqual:other];
    });
}

NSSet *__ASTWithout_NSSet(NSSet *set, id obj) {
    return ASTReject(set, ^BOOL(id other) {
        return [obj isEqual:other];
    });
}

NSOrderedSet *__ASTWithout_NSOrderedSet(NSOrderedSet *set, id obj) {
    return ASTReject(set, ^BOOL(id other) {
        return [obj isEqual:other];
    });
}
