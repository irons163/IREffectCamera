//
//  IRAlbum.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRAlbum.h"
@import MobileCoreServices;

@implementation IRAlbum

#pragma mark -
#pragma mark - Public methods

+ (UIImage *)imageWithMediaInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *) kUTTypeImage]) {
        return info[UIImagePickerControllerOriginalImage];
    }
    
    return nil;
}

+ (BOOL)isAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

+ (UIImagePickerController *)imagePickerControllerWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate
{
    UIImagePickerController *pickerController = [UIImagePickerController new];
    
    pickerController = [UIImagePickerController new];
    pickerController.delegate = delegate;
    pickerController.mediaTypes = @[(NSString *) kUTTypeImage];
    pickerController.allowsEditing = NO;
    pickerController.modalPresentationStyle = UIModalPresentationPopover;
    
    return pickerController;
}

@end
