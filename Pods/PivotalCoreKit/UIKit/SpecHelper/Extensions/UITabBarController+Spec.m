#import "UITabBarController+Spec.h"

@implementation UITabBarController (Spec)

- (void)tapTabAtIndex:(NSUInteger)position {
    if (self.viewControllers.count <= position) {
        [[NSException exceptionWithName:@"Untappable" reason:@"TabBarController does not have a tab at that index" userInfo:nil] raise];
    }
    if ([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        if ([self.delegate tabBarController:self shouldSelectViewController:self.viewControllers[position]]) {
            [self selectControllerAtIndex:position];
        }
    } else {
        [self selectControllerAtIndex:position];
    }
}

- (void)selectControllerAtIndex:(NSUInteger)position {
    [self setSelectedIndex:position];
    [self notifyDelegateOfSelection:self.viewControllers[position]];
}

- (void)notifyDelegateOfSelection:(UIViewController *)controller {
    if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [self.delegate tabBarController:self didSelectViewController:controller];
    }
}

@end
