#import <UIKit/UIKit.h>

@interface UIAlertView (Spec)

+ (UIAlertView *)currentAlertView;
+ (void)reset;

- (void)dismissWithOkButton;
- (void)dismissWithCancelButton;

@end
