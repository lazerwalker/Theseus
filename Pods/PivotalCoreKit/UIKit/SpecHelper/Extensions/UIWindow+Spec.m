#import "UIWindow+Spec.h"

UIView * findFirstResponderInView(UIView *view) {
    for (UIView *subview in view.subviews) {
        if (subview.isFirstResponder) return subview;
        UIView *firstResponder = findFirstResponderInView(subview);
        if (firstResponder) return firstResponder;
    }
    return nil;
}

@implementation UIWindow (Spec)

- (UIResponder *)firstResponder {
    return findFirstResponderInView(self);
}

@end

