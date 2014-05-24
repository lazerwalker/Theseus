#import "UIControl+Spec.h"

@implementation UIControl (Spec)

- (void)tap {
    if (self.hidden) {
        [[NSException exceptionWithName:@"Untappable" reason:@"Can't tap an invisible control" userInfo:nil] raise];
    }
    if (!self.isEnabled) {
        [[NSException exceptionWithName:@"Untappable" reason:@"Can't tap a disabled control" userInfo:nil] raise];
    }
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
