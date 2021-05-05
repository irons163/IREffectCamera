//
//  IRCameraShot.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCameraShot.h"

@interface IRCameraShot ()

+ (UIImage *)cropImage:(UIImage *)image withCropSize:(CGSize)cropSize;

@end



@implementation IRCameraShot

+ (void)takePhotoCaptureView:(UIView *)captureView stillImageOutput:(AVCaptureStillImageOutput *)stillImageOutput videoOrientation:(AVCaptureVideoOrientation)videoOrientation cropSize:(CGSize)cropSize completion:(void (^)(UIImage *))completion
{
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in [stillImageOutput connections]) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    [videoConnection setVideoOrientation:videoOrientation];
    
    __weak __typeof(self)weakSelf = self;
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
    completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            if (!CGSizeEqualToSize(cropSize, CGSizeZero)) {
                image = [weakSelf cropImage:image withCropSize:cropSize];
            }
            completion(image);
        }
    }];
}

+ (void)takePhotoCaptureView:(UIView *)captureView sampleBuffer:(CMSampleBufferRef)imageDataSampleBuffer cropSize:(CGSize)cropSize completion:(void (^)(UIImage *))completion
{
    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
    UIImage *image = [UIImage imageWithData:imageData];
    if (!CGSizeEqualToSize(cropSize, CGSizeZero)) {
        image = [self cropImage:image withCropSize:cropSize];
    }
    completion(image);
}

+ (void)takePhotoCaptureView:(UIView *)captureView image:(UIImage *)image cropSize:(CGSize)cropSize completion:(void (^)(UIImage *))completion
{
    if (!CGSizeEqualToSize(cropSize, CGSizeZero)) {
        image = [self cropImage:image withCropSize:cropSize];
    }
    completion(image);
}

#pragma mark -
#pragma mark - Private methods

+ (UIImage *)cropImage:(UIImage *)image withCropSize:(CGSize)cropSize
{
    UIImage *newImage = nil;
    
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = cropSize.width;
    CGFloat targetHeight = cropSize.height;
    
    CGFloat scaleFactor = 0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0, 0);
    
    if (CGSizeEqualToSize(imageSize, cropSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        

        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * .5f;
        } else {
            if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * .5f;
            }
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(cropSize, YES, 0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [image drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

