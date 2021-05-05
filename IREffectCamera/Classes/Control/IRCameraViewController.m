//
//  IRCameraViewController.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCameraViewController.h"
#import "IRCameraSlideView.h"
#import "IRTintedButton.h"
#import "IRPhotoViewController.h"
#import "IRAlbum.h"
#import "UIImage+Bundle.h"

@interface IRCameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *captureView;
@property (strong, nonatomic) IBOutlet UIImageView *topLeftView;
@property (strong, nonatomic) IBOutlet UIImageView *topRightView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomLeftView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomRightView;
@property (strong, nonatomic) IBOutlet UIView *separatorView;
@property (strong, nonatomic) IBOutlet UIView *actionsView;
@property (strong, nonatomic) IBOutlet IRTintedButton *gridButton;
@property (strong, nonatomic) IBOutlet IRTintedButton *toggleButton;
@property (strong, nonatomic) IBOutlet UIButton *flashButton;
@property (strong, nonatomic) IBOutlet IRTintedButton *closeButton;
@property (strong, nonatomic) IBOutlet IRTintedButton *shotButton;
@property (strong, nonatomic) IBOutlet IRTintedButton *albumButton;
@property (strong, nonatomic) IBOutlet IRCameraSlideView *slideUpView;
@property (strong, nonatomic) IBOutlet IRCameraSlideView *slideDownView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightFixed;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toggleButtonWidth;

@property (strong, nonatomic) IRCamera *camera;
@property (nonatomic) BOOL wasLoaded;

- (IBAction)closeTapped;
- (IBAction)gridTapped;
//- (IBAction)flashTapped;
- (IBAction)shotTapped;
- (IBAction)faceStickerTapped;
- (IBAction)albumTapped;
- (IBAction)toggleTapped;
- (IBAction)handleTapGesture:(UITapGestureRecognizer *)recognizer;

- (void)deviceOrientationDidChangeNotification;
- (AVCaptureVideoOrientation)videoOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation;
- (void)viewWillDisappearWithCompletion:(void (^)(void))completion;

@end

@implementation IRCameraViewController

- (instancetype)init
{
    return [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle bundleForClass:self.class]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices.count > 1) {
        if ([[IRCamera getOption:kIRCameraOptionHiddenToggleButton] boolValue] == YES) {
            _toggleButton.hidden = YES;
            _toggleButtonWidth.constant = 0;
        }
    } else {
        if ([[IRCamera getOption:kIRCameraOptionHiddenToggleButton] boolValue] == YES) {
            _toggleButton.hidden = YES;
            _toggleButtonWidth.constant = 0;
        }
    }
    
    if ([[IRCamera getOption:kIRCameraOptionHiddenAlbumButton] boolValue] == YES) {
        _albumButton.hidden = YES;
    }
    
    if ([[IRCamera getOption:kIRCameraOptionUseOriginalAspect] boolValue] == YES) {
        _bottomViewHeightFixed.active = YES;
    } else {
        _bottomViewHeightFixed.active = NO;
    }
    
    [_albumButton.layer setCornerRadius:10.f];
    [_albumButton.layer setMasksToBounds:YES];
    
    [_closeButton setImage:[UIImage imageNamedForCurrentBundle:@"CameraClose"] forState:UIControlStateNormal];
    [_shotButton setImage:[UIImage imageNamedForCurrentBundle:@"CameraShot"] forState:UIControlStateNormal];
    [_albumButton setImage:[UIImage imageNamedForCurrentBundle:@"CameraRoll"] forState:UIControlStateNormal];
    [_gridButton setImage:[UIImage imageNamedForCurrentBundle:@"CameraGrid"] forState:UIControlStateNormal];
    [_toggleButton setImage:[UIImage imageNamedForCurrentBundle:@"CameraToggle"] forState:UIControlStateNormal];
    
    _camera = [IRCamera cameraWithFlashButton:_flashButton];
    
    _captureView.backgroundColor = [UIColor clearColor];
    
    _topLeftView.transform = CGAffineTransformMakeRotation(0);
    _topRightView.transform = CGAffineTransformMakeRotation(M_PI_2);
    _bottomLeftView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _bottomRightView.transform = CGAffineTransformMakeRotation(M_PI_2*2);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChangeNotification)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    _separatorView.hidden = NO;
    
    _actionsView.hidden = YES;
    
    _topLeftView.hidden =
    _topRightView.hidden =
    _bottomLeftView.hidden =
    _bottomRightView.hidden = YES;
    
    _gridButton.enabled =
    _toggleButton.enabled =
    _shotButton.enabled =
    _albumButton.enabled =
    _flashButton.enabled = NO;
    
    [_camera startRunning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self deviceOrientationDidChangeNotification];
    
    _separatorView.hidden = YES;
    
    [IRCameraSlideView hideSlideUpView:_slideUpView slideDownView:_slideDownView atView:_captureView completion:^{
        
        _actionsView.hidden = NO;
        _gridButton.enabled =
        _toggleButton.enabled =
        _shotButton.enabled =
        _albumButton.enabled =
        _flashButton.enabled = YES;
    }];
    
    if (_wasLoaded == NO) {
        _wasLoaded = YES;
        [_camera insertSublayerWithCaptureView:_captureView atRootView:self.view];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_camera stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *photo = [IRAlbum imageWithMediaInfo:info];
    
    BOOL customizePhotoProcessingView = NO;
    if ([_delegate respondsToSelector:@selector(customizePhotoProcessingView)]) {
        customizePhotoProcessingView = [_delegate customizePhotoProcessingView];
    }
    
    if (!customizePhotoProcessingView) {
        IRPhotoViewController *viewController = [IRPhotoViewController newWithDelegate:_delegate photo:photo];
        [viewController setAlbumPhoto:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:viewController animated:YES];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [picker dismissViewControllerAnimated:YES completion:nil];
        });
        
    } else {
        if ([_delegate respondsToSelector:@selector(cameraDidTakePhoto:)]) {
            [_delegate cameraDidSelectAlbumPhoto:photo];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - Actions

- (IBAction)closeTapped
{
    if ([_delegate respondsToSelector:@selector(cameraDidCancel)]) {
        [_delegate cameraDidCancel];
    }
}

- (IBAction)gridTapped
{
    [_camera displayGridView];
}

- (IBAction)flashTapped
{
    [_camera changeFlashModeWithButton:_flashButton];
}

- (IBAction)shotTapped
{
#if !TARGET_IPHONE_SIMULATOR
    _shotButton.enabled =
    _albumButton.enabled = NO;
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation videoOrientation = [self videoOrientationForDeviceOrientation:deviceOrientation];
    
    CGSize cropSize;
    if ([[IRCamera getOption:kIRCameraOptionUseOriginalAspect] boolValue] == YES) {
        cropSize = CGSizeZero;
    } else {
        cropSize = _captureView.frame.size;
    }
    
    dispatch_group_t group = dispatch_group_create();
    __block UIImage *photo;
    
    dispatch_group_enter(group);
    [self viewWillDisappearWithCompletion:^{
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [_camera takePhotoWithCaptureView:_captureView videoOrientation:videoOrientation cropSize:cropSize completion:^(UIImage *_photo) {
        photo = _photo;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        BOOL customizePhotoProcessingView = NO;
        if ([self->_delegate respondsToSelector:@selector(customizePhotoProcessingView)]) {
            customizePhotoProcessingView = [self->_delegate customizePhotoProcessingView];
        }
        
        if (!customizePhotoProcessingView) {
            IRPhotoViewController *viewController = [IRPhotoViewController newWithDelegate:self->_delegate photo:photo];
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            if ([self->_delegate respondsToSelector:@selector(cameraDidTakePhoto:)]) {
                [self->_delegate cameraDidTakePhoto:photo];
            }
        }
    });
#endif
}

- (IBAction)albumTapped
{
    _shotButton.enabled =
    _albumButton.enabled = NO;
    
    [self viewWillDisappearWithCompletion:^{
        UIImagePickerController *pickerController = [IRAlbum imagePickerControllerWithDelegate:self];
        pickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        pickerController.popoverPresentationController.sourceView = self.albumButton;
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
}

- (IBAction)faceStickerTapped {
    [_camera displayFaceSticker];
}

- (IBAction)toggleTapped
{
    [_camera toogleWithFlashButton:_flashButton];
}

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:_captureView];
    [_camera focusView:_captureView inTouchPoint:touchPoint];
}

#pragma mark -
#pragma mark - Private methods

- (void)deviceOrientationDidChangeNotification
{
    UIDeviceOrientation orientation = [UIDevice.currentDevice orientation];
    NSInteger degrees;
    
    switch (orientation) {
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationUnknown:
            degrees = 0;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            degrees = 90;
            break;
            
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationPortraitUpsideDown:
            degrees = 180;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            degrees = 270;
            break;
    }
    
    CGFloat radians = degrees * M_PI / 180;
    CGAffineTransform transform = CGAffineTransformMakeRotation(radians);
    
    [UIView animateWithDuration:.5f animations:^{
        _gridButton.transform =
        _toggleButton.transform =
        _albumButton.transform =
        _flashButton.transform = transform;
    }];
}

- (AVCaptureVideoOrientation)videoOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation) deviceOrientation;
    
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            result = AVCaptureVideoOrientationLandscapeRight;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            result = AVCaptureVideoOrientationLandscapeLeft;
            break;
            
        default:
            break;
    }
    
    return result;
}

- (void)viewWillDisappearWithCompletion:(void (^)(void))completion
{
    _actionsView.hidden = YES;
    
    [IRCameraSlideView showSlideUpView:_slideUpView slideDownView:_slideDownView atView:_captureView completion:^{
        completion();
    }];
}

@end
