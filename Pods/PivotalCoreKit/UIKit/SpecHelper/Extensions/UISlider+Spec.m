#import "UISlider+Spec.h"

@implementation UISlider (Spec)

- (void)slideTo:(float)value {
    if (self.hidden) {
        [[NSException exceptionWithName:@"Unslideable" reason:@"Can't slide an invisible control" userInfo:nil] raise];
    }
    if (!self.isEnabled) {
        [[NSException exceptionWithName:@"Unslideable" reason:@"Can't slide a disabled control" userInfo:nil] raise];
    }
    [self setValue:value animated:NO];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
