//
//  ASTExtend.m
//  Asterism
//
//  Created by Robert Böhnke on 24/11/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTExtend.h"

NSDictionary *__ASTExtend_NSDictionary(NSDictionary *dict, NSDictionary *source) {
    if (dict == nil) return source;
    if (source == nil) return dict;

    NSMutableDictionary *result = [dict mutableCopy];

    [source enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        result[key] = obj;
    }];

    return result;
}
