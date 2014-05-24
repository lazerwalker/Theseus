#import "UIAlertView+Spec.h"


@implementation UIAlertView (Spec)

static NSMutableArray *alertViewStack__ = nil;

+ (void)afterEach {
    [self reset];
}

+ (UIAlertView *)currentAlertView {
    return [alertViewStack__ lastObject];
}

+ (void)reset {
    [alertViewStack__ release];
    alertViewStack__ = nil;
}

+ (void)setCurrentAlertView:(UIAlertView *)alertView {
    if (!alertViewStack__) {
        alertViewStack__ = [[NSMutableArray array] retain];
    }
    [alertViewStack__ addObject:alertView];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)show {
    [UIAlertView setCurrentAlertView:self];
    if ([self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.delegate willPresentAlertView:self];
    }
}

- (BOOL)isVisible {
    return [UIAlertView currentAlertView] == self;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:buttonIndex];
    }
    if ([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.delegate alertView:self willDismissWithButtonIndex:buttonIndex];
    }
    if ([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
    }
    [alertViewStack__ removeObject:self];
}
#pragma clang diagnostic pop

- (void)dismissWithOkButton {
    [self dismissWithClickedButtonIndex:self.firstOtherButtonIndex animated:NO];
}

- (void)dismissWithCancelButton {
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
}

@end
