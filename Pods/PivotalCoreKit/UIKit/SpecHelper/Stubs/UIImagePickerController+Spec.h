#import <UIKit/UIKit.h>

@interface UIImagePickerController (Spec)

+ (void)setPhotoLibraryAvailable:(BOOL)available;
+ (void)setCameraAvailable:(BOOL)available;
+ (void)setSavedPhotosAlbumAvailable:(BOOL)available;

+ (BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType;

@end
