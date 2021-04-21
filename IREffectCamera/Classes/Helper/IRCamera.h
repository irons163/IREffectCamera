//
//  IRCamera.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@import AVFoundation;

#define kIRCameraOptionHiddenToggleButton @"IRCameraOptionHiddenToggleButton"
#define kIRCameraOptionHiddenAlbumButton @"IRCameraOptionHiddenAlbumButton"
#define kIRCameraOptionHiddenFilterButton @"IRCameraOptionHiddenFilterButton"
#define kIRCameraOptionSaveImageToAlbum @"IRCameraOptionSaveImageToAlbum"
#define kIRCameraOptionUseOriginalAspect @"kIRCameraOptionUseOriginalAspect"

NS_ASSUME_NONNULL_BEGIN

@protocol IRCameraDelegate <NSObject>

- (void)cameraDidCancel;
- (void)cameraDidSelectAlbumPhoto:(UIImage *)image;
- (void)cameraDidTakePhoto:(UIImage *)image;

@optional

- (void)cameraDidSavePhotoWithError:(NSError *)error;
- (void)cameraDidSavePhotoAtPath:(NSURL *)assetURL;
- (void)cameraWillTakePhoto;
- (BOOL)customizePhotoProcessingView;

@end

@interface IRCamera : NSObject

+ (instancetype)new __attribute__
((unavailable("[+new] is not allowed, use [+cameraWithRootView:andCaptureView:]")));

- (instancetype) init __attribute__
((unavailable("[-init] is not allowed, use [+cameraWithRootView:andCaptureView:]")));

+ (instancetype)cameraWithFlashButton:(UIButton *)flashButton;
+ (instancetype)cameraWithFlashButton:(UIButton *)flashButton devicePosition:(AVCaptureDevicePosition)devicePosition;

+ (void)setOption:(NSString*)option value:(id)value;
+ (id)getOption:(NSString*)option;

- (void)startRunning;
- (void)stopRunning;

- (AVCaptureVideoPreviewLayer *)previewLayer;
- (AVCaptureStillImageOutput *)stillImageOutput;

- (void)insertSublayerWithCaptureView:(UIView *)captureView atRootView:(UIView *)rootView;

- (void)displayGridView;

- (void)changeFlashModeWithButton:(UIButton *)button;

- (void)focusView:(UIView *)focusView inTouchPoint:(CGPoint)touchPoint;

- (void)takePhotoWithCaptureView:(UIView *)captureView
                videoOrientation:(AVCaptureVideoOrientation)videoOrientation
                        cropSize:(CGSize)cropSize
                      completion:(void (^)(UIImage *))completion;

- (void)toogleWithFlashButton:(UIButton *)flashButton;

@end

NS_ASSUME_NONNULL_END
