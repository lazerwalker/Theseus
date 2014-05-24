#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (Spec)
+(void)afterEach;
-(void)recognize;
+(void)whitelistClassForGestureSnooping:(Class)klass;
@end
