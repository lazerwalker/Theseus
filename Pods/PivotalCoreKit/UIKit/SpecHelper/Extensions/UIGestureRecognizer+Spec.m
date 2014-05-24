#import "UIGestureRecognizer+Spec.h"
#import "objc/runtime.h"
#import <UIKit/UITextField.h>

@interface UIGestureRecognizer (Spec_Private)
- (void) addUnswizzledTarget:(id)target action:(SEL)action;
- (void) removeUnswizzledTarget:(id)target action:(SEL)action;
- (instancetype) initWithoutSwizzledTarget:(id)target action:(SEL)action;
@end

@implementation UIGestureRecognizer (Spec)

#pragma mark - TODO Refactor to use code in Foundation project
+ (void)redirectSelector:(SEL)originalSelector to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector {
    [self redirectSelector:originalSelector
                      forClass:[self class]
                            to:newSelector
                 andRenameItTo:renamedSelector];

}

+ (void)redirectSelector:(SEL)originalSelector forClass:(Class)klass to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector {
    if ([klass instancesRespondToSelector:renamedSelector]) {
        return;
    }

    Method originalMethod = class_getInstanceMethod(klass, originalSelector);
    class_addMethod(klass, renamedSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));

    Method newMethod = class_getInstanceMethod(klass, newSelector);
    class_replaceMethod(klass, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
}

#pragma mark - Setup
+(void)load {
    [self redirectSelector:@selector(addTarget:action:)
                        to:@selector(addSnoopedTarget:action:)
             andRenameItTo:@selector(addUnswizzledTarget:action:)];

    [self redirectSelector:@selector(removeTarget:action:)
                        to:@selector(removeSnoopedTarget:action:)
             andRenameItTo:@selector(removeUnswizzledTarget:action:)];

    [self redirectSelector:@selector(initWithTarget:action:)
                        to:@selector(initWithSwizzledTarget:action:)
             andRenameItTo:@selector(initWithoutSwizzledTarget:action:)];

    whitelistedClasses = [[NSMutableArray alloc] init];
}

-(instancetype)initWithSwizzledTarget:(id)target action:(SEL)action {
    if (self = [self initWithoutSwizzledTarget:target action:action]) {
        [self setTargetsAndActions:[[[NSMutableArray alloc] init] autorelease]];
        if(target && action) {
            [self addSnoopedTarget:target action:action];
        }
    }

    return self;
}

+(void)afterEach {
    [whitelistedClasses removeAllObjects];
}

#pragma mark - Public interface
-(void)recognize {
    if (self.view.hidden) {
        [[NSException exceptionWithName:@"Unrecognizable" reason:@"Can't recognize when in a hidden view" userInfo:nil] raise];
    }
    if (!self.enabled) {
        [[NSException exceptionWithName:@"Unrecognizable" reason:@"Can't recognize when recognizer is disabled" userInfo:nil] raise];
    }

    [self.targetsAndActions enumerateObjectsUsingBlock:^(NSArray *targetSelectorPair, NSUInteger index, BOOL *stop) {
        id target = [targetSelectorPair firstObject];
        SEL action = [[targetSelectorPair lastObject] pointerValue];

        [target performSelector:action withObject:self];
    }];
}

static NSMutableArray *whitelistedClasses;
+(void)whitelistClassForGestureSnooping:(Class)klass {
    [whitelistedClasses addObject:klass];
}

#pragma mark - swizzled methods
-(void)addSnoopedTarget:(id)target action:(SEL)action {
    [self addUnswizzledTarget:target action:action];

    NSMutableArray *targetsAndActions = [self targetsAndActions];

    if (![whitelistedClasses containsObject:[target class]]) {
        return;
    }

    [targetsAndActions addObject:@[target, [NSValue valueWithPointer:action]]];
    [self setTargetsAndActions:targetsAndActions];
}

-(void)removeSnoopedTarget:(id)target action:(SEL)action {
    [self removeUnswizzledTarget:target action:action];

    if (![whitelistedClasses containsObject:[target class]]) {
        return;
    }

    NSMutableArray *targetsAndActions = [self targetsAndActions];
    NSPredicate *targetAndActionPredicate = [NSPredicate predicateWithBlock:^BOOL(NSMutableArray *targetAndActionPair, NSDictionary *bindings) {
        id storedTarget = [targetAndActionPair firstObject];
        SEL storedAction = [[targetAndActionPair lastObject] pointerValue];
        return storedTarget == target && storedAction == action;
    }];

    NSArray *matchingTargetsAndActions = [targetsAndActions filteredArrayUsingPredicate:targetAndActionPredicate];
    [targetsAndActions removeObjectsInArray:matchingTargetsAndActions];
    [self setTargetsAndActions:targetsAndActions];
}

#pragma mark - targetsAndActions
static char const * const targetAndActionsKey = "targetAndActionKey";

-(NSMutableArray *) targetsAndActions {
    return objc_getAssociatedObject(self, &targetAndActionsKey);
}

-(void) setTargetsAndActions:(NSMutableArray *)targetsAndActions {
    objc_setAssociatedObject(self, &targetAndActionsKey, targetsAndActions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
