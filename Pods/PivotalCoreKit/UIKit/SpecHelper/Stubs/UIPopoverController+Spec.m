#import "UIPopoverController+Spec.h"

@implementation UIPopoverController (Spec)

static UIPopoverController *currentPopoverController__;
static UIPopoverArrowDirection arrowDirectionMask__;

+ (instancetype)currentPopoverController {
    return currentPopoverController__;
}

+ (void)reset {
    currentPopoverController__ = nil;
}

+ (void)afterEach {
    [self reset];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)dealloc {
    // [super dealloc] will raise an exception if -isPopoverVisible is YES when deallocating
    if (self == currentPopoverController__) {
        currentPopoverController__ = nil;
    }
}

// -presentPopoverFromBarButtonItem:permittedArrowDirections:animated: calls through to this method
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated {
    currentPopoverController__ = self;
    arrowDirectionMask__ = arrowDirections;
}

- (void)dismissPopoverAnimated:(BOOL)animated {
    if (self == currentPopoverController__) {
        currentPopoverController__ = nil;
    }
}

- (BOOL)isPopoverVisible {
    return (self == currentPopoverController__);
}

- (UIPopoverArrowDirection)popoverArrowDirection {
    return arrowDirectionMask__;
}

#pragma clang diagnostic pop

@end
