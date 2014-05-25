//
//  ASTDefaults.m
//  Asterism
//
//  Created by Robert Böhnke on 16/11/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTDefaults.h"

NSDictionary *__ASTDefaults_NSDictionary(NSDictionary *dict, NSDictionary *defaults) {
    if (dict == nil) return defaults;
    if (defaults == nil) return dict;

    NSMutableDictionary *result = [dict mutableCopy];

    [defaults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (result[key] == nil) result[key] = obj;
    }];

    return result;
}
