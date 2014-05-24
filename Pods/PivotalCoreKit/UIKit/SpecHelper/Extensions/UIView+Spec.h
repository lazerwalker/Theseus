#import <UIKit/UIKit.h>

@interface UIView (Spec)
- (UIView *)subviewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier;

- (void)tap;
- (void)swipe;
- (void)pinch;

@end
