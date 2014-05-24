#import "UIImagePickerController+Spec.h"

static BOOL isCameraAvailable__, isPhotoLibraryAvailable__, isSavedPhotosAlbumAvailable__;

@implementation UIImagePickerController (Spec)

+ (void)initialize {
    isCameraAvailable__ = isPhotoLibraryAvailable__ = isSavedPhotosAlbumAvailable__ = YES;
}

+ (void)setPhotoLibraryAvailable:(BOOL)available {
    isPhotoLibraryAvailable__ = available;
}

+ (void)setCameraAvailable:(BOOL)available {
    isCameraAvailable__ = available;
}

+ (void)setSavedPhotosAlbumAvailable:(BOOL)available {
    isSavedPhotosAlbumAvailable__ = available;
}

#pragma mark - Overrides

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
+ (BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType {
    switch (sourceType) {
        case UIImagePickerControllerSourceTypePhotoLibrary:
            return isPhotoLibraryAvailable__;
        case UIImagePickerControllerSourceTypeCamera:
            return isCameraAvailable__;
        case UIImagePickerControllerSourceTypeSavedPhotosAlbum:
            return isSavedPhotosAlbumAvailable__;
        default:
            return NO;
    }
}
#pragma clang diagnostic pop
@end
