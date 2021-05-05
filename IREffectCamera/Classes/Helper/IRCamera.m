//
//  IRCamera.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCamera.h"
#import "IRCameraGrid.h"
#import "IRCameraGridView.h"
#import "IRCameraFlash.h"
#import "IRCameraFocus.h"
#import "IRCameraShot.h"
#import "IRCameraToggle.h"
#import <GPUImage/GPUImage.h>
#import <IRCameraSticker/IRCameraSticker.h>
#import <IRCameraSticker/IRCameraStickerFilter.h>
#import <IRCameraSticker/IRCameraStickersManager.h>

@import Vision;

NSMutableDictionary *optionDictionary;

@interface IRCamera () <GPUImageVideoCameraDelegate>

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *filterView;

@property (nonatomic, strong) IRCameraStickerFilter *stickerFilter;

@property (nonatomic, copy) NSArray<IRCameraSticker *> *stickers;

@property (strong, nonatomic) AVCaptureSession *session;
//@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
//@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) IRCameraGridView *gridView;

@property (nonatomic) BOOL enableFaceSticker;

+ (instancetype)newCamera;
+ (void)initOptions;

- (void)setupWithFlashButton:(UIButton *)flashButton;

@end



@implementation IRCamera

+ (instancetype)cameraWithFlashButton:(UIButton *)flashButton
{
    IRCamera *camera = [IRCamera newCamera];
#if !TARGET_IPHONE_SIMULATOR
    [camera setupWithFlashButton:flashButton];
#endif
    return camera;
}

+ (instancetype)cameraWithFlashButton:(UIButton *)flashButton devicePosition:(AVCaptureDevicePosition)devicePosition
{
    IRCamera *camera = [IRCamera newCamera];
#if !TARGET_IPHONE_SIMULATOR
    [camera setupWithFlashButton:flashButton devicePosition:devicePosition];
#endif
    return camera;
}


+ (void)setOption:(NSString *)option value:(id)value
{
    if (optionDictionary == nil) {
        [IRCamera initOptions];
    }
    
    if (option != nil && value != nil) {
        optionDictionary[option] = value;
    }
}

+ (id)getOption:(NSString *)option
{
    if (optionDictionary == nil) {
        [IRCamera initOptions];
    }
    
    if (option != nil) {
        return optionDictionary[option];
    }
    
    return nil;
}

#pragma mark -
#pragma mark - Public methods

- (void)startRunning
{
    //    [_session startRunning];
    [self.videoCamera startCameraCapture];
}

- (void)stopRunning
{
    //    [_session stopRunning];
    [self.videoCamera stopCameraCapture];
}

- (void)insertSublayerWithCaptureView:(UIView *)captureView atRootView:(UIView *)rootView
{
    //    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    //    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.videoCamera.delegate = self;
    
    self.stickerFilter = [IRCameraStickerFilter new];
    [self.videoCamera addTarget:self.stickerFilter];
    _session = self.videoCamera.captureSession;
    
    
    CALayer *rootLayer = [rootView layer];
    rootLayer.masksToBounds = YES;
    
    CGRect frame = captureView.frame;
    
    self.filterView = [[GPUImageView alloc] initWithFrame:frame];
    self.filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    self.filterView.center = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2);
    
    self.filterView.layer.frame = frame;
    
    [self.stickerFilter addTarget:self.filterView];
    [self.videoCamera startCameraCapture];
    
    [IRCameraStickersManager loadStickersWithCompletion:^(NSArray<IRCameraSticker *> *stickers) {
        self.stickers = stickers;
        self.stickerFilter.sticker = [stickers firstObject];
    }];
    
    //    _previewLayer.frame = frame;
    //
    [rootLayer insertSublayer:self.filterView.layer atIndex:0];
    
    NSInteger index = [captureView.subviews count]-1;
    [captureView insertSubview:self.gridView atIndex:index];
}

- (void)displayGridView
{
    [IRCameraGrid displayGridView:self.gridView];
}

- (void)displayFaceSticker
{
    self.enableFaceSticker = !self.enableFaceSticker;
}

- (void)changeFlashModeWithButton:(UIButton *)button
{
//    NSError *error = nil;
//    if (![self.videoCamera.inputCamera lockForConfiguration:&error])
//    {
//       NSLog(@"Error locking for configuration: %@", error);
//    }
//    [self.videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
//    [self.videoCamera.inputCamera unlockForConfiguration];
//    [IRCameraFlash changeModeWithCaptureSession:_session andButton:button];
    [IRCameraFlash changeModeWithCaptureDevice:self.videoCamera.inputCamera andButton:button];
}

- (void)focusView:(UIView *)focusView inTouchPoint:(CGPoint)touchPoint
{
    [IRCameraFocus focusWithCaptureSession:_session touchPoint:touchPoint inFocusView:focusView];
}

- (void)takePhotoWithCaptureView:(UIView *)captureView videoOrientation:(AVCaptureVideoOrientation)videoOrientation cropSize:(CGSize)cropSize completion:(void (^)(UIImage *))completion
{
    [self.stickerFilter useNextFrameForImageCapture];
    [IRCameraShot takePhotoCaptureView:captureView image:[self.stickerFilter imageFromCurrentFramebufferWithOrientation:[self getImageOrientationWithVideoOrientation:videoOrientation]] cropSize:cropSize completion:^(UIImage *photo) {
        completion(photo);
    }];
}

- (UIImageOrientation)getImageOrientationWithVideoOrientation:(AVCaptureVideoOrientation)videoOrientation {
    
    UIImageOrientation imageOrientation;
    switch (videoOrientation) {
        case AVCaptureVideoOrientationLandscapeLeft:
            imageOrientation = UIImageOrientationLeft;
            break;
        case AVCaptureVideoOrientationLandscapeRight:
            imageOrientation = UIImageOrientationRight;
            break;
        case AVCaptureVideoOrientationPortrait:
            imageOrientation = UIImageOrientationUp;
            break;
        case AVCaptureVideoOrientationPortraitUpsideDown:
            imageOrientation = UIImageOrientationDown;
            break;
        default:
            imageOrientation = UIImageOrientationUp;
            break;
    }
    return imageOrientation;
}

- (void)toogleWithFlashButton:(UIButton *)flashButton
{
    //    [IRCameraToggle toogleWithCaptureSession:_session];
    [self.videoCamera rotateCamera];
//    [IRCameraFlash flashModeWithCaptureSession:_session andButton:flashButton];
    [IRCameraFlash changeModeWithCaptureDevice:self.videoCamera.inputCamera andButton:flashButton];
}

#pragma mark -
#pragma mark - Private methods

+ (instancetype)newCamera
{
    return [super new];
}

- (IRCameraGridView *)gridView
{
    if (_gridView == nil) {
        CGRect frame = self.filterView.frame;
        frame.origin.x = frame.origin.y = 0;
        
        _gridView = [[IRCameraGridView alloc] initWithFrame:frame];
        _gridView.numberOfColumns = 2;
        _gridView.numberOfRows = 2;
        _gridView.alpha = 0;
    }
    
    return _gridView;
}

- (void)setupWithFlashButton:(UIButton *)flashButton
{
    // create session
    _session = [AVCaptureSession new];
    _session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    // setup device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device lockForConfiguration:nil]) {
        if (device.autoFocusRangeRestrictionSupported) {
            device.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
        }
        
        if (device.smoothAutoFocusSupported) {
            device.smoothAutoFocusEnabled = YES;
        }
        
        if([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]){
            device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        }
        
        device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        
        [device unlockForConfiguration];
    }
    
    // add device input to session
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [_session addInput:deviceInput];
    
    // add output to session
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    
    //    _stillImageOutput = [AVCaptureStillImageOutput new];
    //    _stillImageOutput.outputSettings = outputSettings;
    //
    //    [_session addOutput:_stillImageOutput];
    
    // setup flash button
//    [IRCameraFlash flashModeWithCaptureSession:_session andButton:flashButton];
    [IRCameraFlash changeModeWithCaptureDevice:self.videoCamera.inputCamera andButton:flashButton];
}

- (void)setupWithFlashButton:(UIButton *)flashButton devicePosition:(AVCaptureDevicePosition)devicePosition
{
    // create session
    _session = [AVCaptureSession new];
    _session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    // setup device
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *device;
    for (AVCaptureDevice *aDevice in devices) {
        if (aDevice.position == devicePosition) {
            device = aDevice;
        }
    }
    if (!device) {
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    if ([device lockForConfiguration:nil]) {
        if (device.autoFocusRangeRestrictionSupported) {
            device.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
        }
        
        if (device.smoothAutoFocusSupported) {
            device.smoothAutoFocusEnabled = YES;
        }
        
        if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        }
        
        device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        
        [device unlockForConfiguration];
    }
    
    // add device input to session
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [_session addInput:deviceInput];
    
    // add output to session
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    
    //    _stillImageOutput = [AVCaptureStillImageOutput new];
    //    _stillImageOutput.outputSettings = outputSettings;
    //
    //    [_session addOutput:_stillImageOutput];
    
    // setup flash button
//    [IRCameraFlash flashModeWithCaptureSession:_session andButton:flashButton];
    [IRCameraFlash changeModeWithCaptureDevice:self.videoCamera.inputCamera andButton:flashButton];
}

+ (void)initOptions
{
    optionDictionary = [NSMutableDictionary dictionary];
}

#pragma mark - GPUImageVideoCameraDelegate
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if (!self.enableFaceSticker) {
        self.stickerFilter.faces = nil;
        return;
    }
    
    CVImageBufferRef frame = CMSampleBufferGetImageBuffer(sampleBuffer);
    [self detectFace:frame];
}

- (void)detectFace:(CVPixelBufferRef)image {
    size_t width = CVPixelBufferGetWidth(image);
    size_t height = CVPixelBufferGetHeight(image);
    
    VNDetectFaceLandmarksRequest *faceDetectionRequest = [[VNDetectFaceLandmarksRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([request.results isKindOfClass:[NSArray<VNFaceObservation *> class]]) {
                [self handleFaceDetectionResults:request.results size:CGSizeMake(width, height)];
            } else {
                self.stickerFilter.faces = nil;
            }
        });
    }];
    
    VNImageRequestHandler *imageRequestHandler = [[VNImageRequestHandler alloc] initWithCVPixelBuffer:image orientation:kCGImagePropertyOrientationLeftMirrored options:0];
    [imageRequestHandler performRequests:@[faceDetectionRequest] error:nil];
}

- (void)handleFaceDetectionResults:(NSArray<VNFaceObservation *> *)observedFaces size:(CGSize)size {
    if (observedFaces.count == 0) {
        self.stickerFilter.faces = nil;
    }
    for (VNFaceObservation *observedFace in observedFaces) {
        if (observedFace.landmarks) {
            [self drawFaceFeatures:observedFace.landmarks WithBoundingBox:observedFace.boundingBox size:size];
        }
    }
}

- (NSMutableArray<CAShapeLayer *> *)drawFaceFeatures:(VNFaceLandmarks2D *)landmarks WithBoundingBox:(CGRect)screenBoundingBox size:(CGSize)size {
    NSMutableArray<CAShapeLayer *> *faceFeaturesDrawings = [NSMutableArray array];
    if (landmarks.allPoints) {
        NSMutableArray *newAllPointsArray = [NSMutableArray array];
        const CGPoint *pointsInImage = [landmarks.allPoints pointsInImageOfSize:CGSizeMake(size.width, size.height)];
        for (int i = 0; i < landmarks.allPoints.pointCount; i++) {
            CGPoint eyePoint = pointsInImage[i];
            
            CGFloat scaleX = (self.filterView.layer.frame.size.width / size.width) * (size.height / self.filterView.layer.frame.size.width);
            CGFloat scaleY = (self.filterView.layer.frame.size.height / size.height) * (size.width / self.filterView.layer.frame.size.height);
            
            CGAffineTransform transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(scaleX, -scaleY), 0, -size.height);
            
            eyePoint = CGPointApplyAffineTransform(eyePoint, transform);
            
            [newAllPointsArray addObject:[NSValue valueWithCGPoint:eyePoint]];
        }
        
        self.stickerFilter.faces = @[newAllPointsArray];
    }
    
    return faceFeaturesDrawings;
}

@end
