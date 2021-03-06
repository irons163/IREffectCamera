//
//  IRCameraFlash.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCameraFlash.h"
#import "IRCameraColor.h"
#import "IRTintedButton.h"
#import "UIImage+Bundle.h"

@implementation IRCameraFlash

#pragma mark -
#pragma mark - Public methods

+ (void)changeModeWithCaptureSession:(AVCaptureSession *)session andButton:(UIButton *)button
{
    AVCaptureDevice *device = [session.inputs.lastObject device];
    AVCaptureFlashMode mode = [device flashMode];

    [device lockForConfiguration:nil];
    
    switch ([device flashMode]) {
        case AVCaptureFlashModeAuto:
            mode = AVCaptureFlashModeOn;
            break;
            
        case AVCaptureFlashModeOn:
            mode = AVCaptureFlashModeOff;
            break;
            
        case AVCaptureFlashModeOff:
            mode = AVCaptureFlashModeAuto;
            break;
    }
    
    if ([device isFlashModeSupported:mode]) {
        device.flashMode = mode;
    }
    
    [device unlockForConfiguration];
    
    [self flashModeWithCaptureSession:session andButton:button];
}

+ (void)changeModeWithCaptureDevice:(AVCaptureDevice *)device andButton:(UIButton *)button
{
    AVCaptureFlashMode mode = [device flashMode];

    [device lockForConfiguration:nil];
    
    switch ([device flashMode]) {
        case AVCaptureFlashModeAuto:
            mode = AVCaptureFlashModeOn;
            break;
            
        case AVCaptureFlashModeOn:
            mode = AVCaptureFlashModeOff;
            break;
            
        case AVCaptureFlashModeOff:
            mode = AVCaptureFlashModeAuto;
            break;
    }
    
    if ([device isFlashModeSupported:mode]) {
        device.flashMode = mode;
    }
    
    [device unlockForConfiguration];
    
    [self flashModeWithCaptureDevice:device andButton:button];
}


+ (void)flashModeWithCaptureSession:(AVCaptureSession *)session andButton:(UIButton *)button
{
    AVCaptureDevice *device = [session.inputs.lastObject device];
    AVCaptureFlashMode mode = [device flashMode];
    UIImage *image = UIImageFromAVCaptureFlashMode(mode);
    UIColor *tintColor = TintColorFromAVCaptureFlashMode(mode);
    button.enabled = [device isFlashModeSupported:mode];
    
    if ([button isKindOfClass:[IRTintedButton class]]) {
        [(IRTintedButton*)button setCustomTintColorOverride:tintColor];
    }
    
    [button setImage:image forState:UIControlStateNormal];
}

+ (void)flashModeWithCaptureDevice:(AVCaptureDevice *)device andButton:(UIButton *)button
{
    AVCaptureFlashMode mode = [device flashMode];
    UIImage *image = UIImageFromAVCaptureFlashMode(mode);
    UIColor *tintColor = TintColorFromAVCaptureFlashMode(mode);
    button.enabled = [device isFlashModeSupported:mode];
    
    if ([button isKindOfClass:[IRTintedButton class]]) {
        [(IRTintedButton*)button setCustomTintColorOverride:tintColor];
    }
    
    [button setImage:image forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark - Private methods

UIImage *UIImageFromAVCaptureFlashMode(AVCaptureFlashMode mode)
{
    NSArray *array = @[@"CameraFlashOff", @"CameraFlashOn", @"CameraFlashAuto"];
    NSString *imageName = [array objectAtIndex:mode];
    return [UIImage imageNamedForCurrentBundle:imageName];
}

UIColor *TintColorFromAVCaptureFlashMode(AVCaptureFlashMode mode)
{
    NSArray *array = @[[UIColor grayColor], [IRCameraColor tintColor], [IRCameraColor tintColor]];
    UIColor *color = [array objectAtIndex:mode];
    return color;
}

@end

