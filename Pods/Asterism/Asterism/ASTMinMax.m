//
//  ASTMinMax.m
//  Asterism
//
//  Created by Robert Böhnke on 6/4/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import "ASTReduce.h"

#import "ASTMinMax.h"

#pragma mark - Helpers

static NSComparator const ASTCompare = ^NSComparisonResult(id a, id b) {
    return [a compare:b];
};

#pragma mark - Min

id __ASTMin_NSDictionary(NSDictionary *dict) {
    return ASTMin(dict.allValues);
}

id __ASTMin_NSDictionary_comparator(NSDictionary *dict, NSComparator comparator) {
    return ASTMin(dict.allValues, comparator);
}

id __ASTMin_NSFastEnumeration(id<NSFastEnumeration> collection) {
    return ASTMin(collection, ASTCompare);
}

id __ASTMin_NSFastEnumeration_comparator(id<NSFastEnumeration> collection, NSComparator comparator) {
    NSCParameterAssert(comparator != nil);

    return ASTReduce(collection, ^id(id a, id b) {
        return comparator(a, b) == NSOrderedAscending ? a : b;
    });
}

#pragma mark - Max

id __ASTMax_NSDictionary(NSDictionary *dict) {
    return ASTMax(dict.allValues);
}

id __ASTMax_NSDictionary_comparator(NSDictionary *dict, NSComparator comparator) {
    return ASTMax(dict.allValues, comparator);
}

id __ASTMax_NSFastEnumeration(id<NSFastEnumeration> collection) {
    return ASTMax(collection, ASTCompare);
}

id __ASTMax_NSFastEnumeration_comparator(id<NSFastEnumeration> collection, NSComparator comparator) {
    NSCParameterAssert(comparator != nil);

    return ASTReduce(collection, ^id(id a, id b) {
        return comparator(a, b) == NSOrderedDescending ? a : b;
    });
}
