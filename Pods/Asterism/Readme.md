# Asterism ⁂

<a href="https://travis-ci.org/robb/Asterism?branch=master">
    <img src="https://travis-ci.org/robb/Asterism.png?branch=master" align="right">
</a>

Asterism is yet another functional toolbelt for Objective-C. It tries to be
typesafe and simple.

```objective-c
NSDictionary *reviewsByRating = ASTGroup(reviews, @"rating");

// Log all five star ratings
ASTEach(reviewsByRating[@5], ^(XYReview *review) {
    NSLog(@"%@", review);
});

XYReview *worstReview = ASTMin(reviews);
```

I'd like Asterism to eventually offer common methods for data structures for all
of Cocoa's collections.

## Supported Operations

Asterism currently supports the following operations:

* [all](Asterism/ASTAll.h)
* [any](Asterism/ASTAny.h)
* [defaults](Asterism/ASTDefaults.h)
* [difference](Asterism/ASTDifference.h)
* [each](Asterism/ASTEach.h)
* [empty](Asterism/ASTEmpty.h)
* [extend](Asterism/ASTExtend.h)
* [filter](Asterism/ASTFilter.h)
* [find](Asterism/ASTFind.h)
* [flatten](Asterism/ASTFlatten.h)
* [groupBy](Asterism/ASTGroupBy.h)
* [head](Asterism/ASTHead.h)
* [indexBy](Asterism/ASTIndexBy.h)
* [indexOf](Asterism/ASTIndexOf.h)
* [intersection](Asterism/ASTIntersection.h)
* [map](Asterism/ASTMap.h)
* [min & max](Asterism/ASTMinMax.h)
* [negate](Asterism/ASTNegate.h)
* [pick](Asterism/ASTPick.h)
* [pluck](Asterism/ASTPluck.h)
* [reduce](Asterism/ASTReduce.h)
* [reject](Asterism/ASTReject.h)
* [shuffle](Asterism/ASTShuffle.h)
* [size](Asterism/ASTSize.h)
* [sort](Asterism/ASTSort.h)
* [tail](Asterism/ASTTail.h)
* [union](Asterism/ASTUnion.h)
* [without](Asterism/ASTWithout.h)
