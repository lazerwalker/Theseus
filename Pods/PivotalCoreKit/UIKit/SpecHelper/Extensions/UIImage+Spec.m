#import "UIImage+Spec.h"

@implementation UIImage (Spec)

- (BOOL)isEqualToByBytes:(UIImage *)otherImage {
    NSData *imagePixelsData = (NSData *)CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage));
    NSData *otherImagePixelsData = (NSData *)CGDataProviderCopyData(CGImageGetDataProvider(otherImage.CGImage));
    
    BOOL comparison = [imagePixelsData isEqualToData:otherImagePixelsData];
    
    CGDataProviderRelease((CGDataProviderRef)imagePixelsData);
    CGDataProviderRelease((CGDataProviderRef)otherImagePixelsData);
    return comparison;
}

@end
