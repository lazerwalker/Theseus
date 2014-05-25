//
//  ASTNegate.m
//  Asterism
//
//  Created by Robert Böhnke on 6/3/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTNegate.h"

BOOL (^__ASTNegate_id(BOOL(^block)(id)))(id) {
    return ^BOOL (id arg1){
        return !block(arg1);
    };
}

BOOL (^__ASTNegate_id_id(BOOL(^block)(id, id)))(id, id) {
    return ^BOOL (id arg1, id arg2){
        return !block(arg1, arg2);
    };
}

BOOL (^__ASTNegate_id_NSUInteger(BOOL(^block)(id, NSUInteger)))(id, NSUInteger) {
    return ^BOOL (id arg1, NSUInteger arg2){
        return !block(arg1, arg2);
    };
}
