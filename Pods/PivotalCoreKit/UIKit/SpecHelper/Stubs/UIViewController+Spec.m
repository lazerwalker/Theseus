#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

static char PRESENTING_CONTROLLER_KEY;
static char PRESENTED_CONTROLLER_KEY;

@implementation UIViewController (Spec)

#pragma mark - Modals

- (void)presentViewController:(UIViewController *)modalViewController animated:(BOOL)animated completion:(void(^)(void))onComplete {
    if (self.modalViewController) {
        NSString *errorReason = [NSString stringWithFormat:@"Presenting modal view controller (%@) with other modal (%@) previously active", modalViewController, self.modalViewController];
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:errorReason userInfo:nil] raise];
    }

    self.presentedViewController = modalViewController;
    modalViewController.presentingViewController = self;
    if (onComplete) {
        onComplete();
    }
}

- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (self.presentedViewController) {
        self.presentedViewController.presentingViewController = nil;
        self.presentedViewController = nil;
    } else if (self.presentingViewController) {
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    } else if (self.navigationController) {
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }

    if (completion) {
        completion();
    }
}

#pragma mark Deprecated Modal APIs

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
    [self presentViewController:modalViewController animated:animated completion:nil];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    [self dismissViewControllerAnimated:animated completion:nil];
}

- (UIViewController *)modalViewController {
    return self.presentedViewController;
}

#pragma mark Modal Properties

- (void)setPresentedViewController:(UIViewController *)modalViewController {
    objc_setAssociatedObject(self, &PRESENTED_CONTROLLER_KEY, modalViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)presentedViewController {
    return objc_getAssociatedObject(self, &PRESENTED_CONTROLLER_KEY);
}

- (void)setPresentingViewController:(UIViewController *)presentingViewController {
    objc_setAssociatedObject(self, &PRESENTING_CONTROLLER_KEY, presentingViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)presentingViewController {
    return objc_getAssociatedObject(self, &PRESENTING_CONTROLLER_KEY);
}

#pragma mark - Animation
- (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    animations();
    completion(YES);
}

- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion {
    animations();
    completion(YES);
}

@end
#pragma clang diagnostic pop
