#import "UIActionSheet+Spec.h"


@implementation UIActionSheet (Spec)

static UIActionSheet *currentActionSheet__;
static UIView *currentActionSheetView__;

+ (void)afterEach {
    [self reset];
}

+ (UIActionSheet *)currentActionSheet {
    return currentActionSheet__;
}

+ (UIView *)currentActionSheetView {
    return currentActionSheetView__;
}

+ (void)reset {
    [self setCurrentActionSheet:nil forView:nil];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (void)setCurrentActionSheet:(UIActionSheet *)actionSheet forView:(UIView *)view {
    [actionSheet retain];
    [view retain];

    [currentActionSheet__ release];
    [currentActionSheetView__ release];

    currentActionSheet__ = actionSheet;
    currentActionSheetView__ = view;
}

- (void)showInView:(UIView *)view {
    [UIActionSheet setCurrentActionSheet:self forView:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated {
    [UIActionSheet setCurrentActionSheet:self forView:(id)item];
}

- (void)showFromToolbar:(UIToolbar *)view {
    [UIActionSheet setCurrentActionSheet:self forView:view];
}

- (void)showFromTabBar:(UITabBar *)view {
    [UIActionSheet setCurrentActionSheet:self forView:view];
}

- (BOOL)isVisible {
    return [UIActionSheet currentActionSheet] == self;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:buttonIndex];
    }
    if ([self.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
        [self.delegate actionSheet:self willDismissWithButtonIndex:buttonIndex];
    }
    if ([self.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
        [self.delegate actionSheet:self didDismissWithButtonIndex:buttonIndex];
    }
    [UIActionSheet reset];
}

#pragma clang diagnostic pop

- (NSArray *)buttonTitles {
    NSMutableArray *titles = [NSMutableArray array];

    for (int i=0; i < self.numberOfButtons; i++) {
        [titles addObject:[self buttonTitleAtIndex:i]];
    }
    return titles;
}

- (void)dismissByClickingButtonWithTitle:(NSString *)buttonTitle {
    NSInteger buttonIndex = (NSInteger)[self.buttonTitles indexOfObject:buttonTitle];
    NSAssert((buttonIndex != NSNotFound), @"Action sheet does not have a button titled '%@' -- current button titles are %@", buttonTitle, self.buttonTitles);
    [self dismissWithClickedButtonIndex:buttonIndex animated:NO];
}

- (void)dismissByClickingDestructiveButton {
    NSAssert((self.destructiveButtonIndex != -1), @"Action sheet does not have a valid index for the destructive button");
    [self dismissWithClickedButtonIndex:self.destructiveButtonIndex animated:NO];
}

- (void)dismissByClickingCancelButton {
    NSAssert((self.cancelButtonIndex != -1), @"Action sheet does not have a valid index for the cancel button");
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
}

@end
