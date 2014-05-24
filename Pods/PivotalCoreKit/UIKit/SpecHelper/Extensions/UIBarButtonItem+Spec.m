#import "UIBarButtonItem+Spec.h"
#import "UIControl+Spec.h"
#import <objc/message.h>


@implementation UIBarButtonItem (Spec)

- (void)tap
{
    if (self.enabled == NO) {
        @throw @"Attempted to tap disabled bar button item";
    }

    if ([self.customView isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self.customView;
        [button tap];
    } else {
        id target = self.target;
        SEL action = self.action;
        objc_msgSend(target, action, nil);
    }
}

@end
