//
//  IRCameraToggle.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCameraToggle.h"

@interface IRCameraToggle ()

+ (AVCaptureDeviceInput *)reverseDeviceInput:(AVCaptureDeviceInput *)deviceInput;

@end



@implementation IRCameraToggle

#pragma mark -
#pragma mark - Public methods

+ (void)toogleWithCaptureSession:(AVCaptureSession *)session
{
    AVCaptureDeviceInput *deviceInput = [session.inputs lastObject];
    AVCaptureDeviceInput *reverseDeviceInput = [self reverseDeviceInput:deviceInput];
    
    [session beginConfiguration];
    [session removeInput:deviceInput];
    [session addInput:reverseDeviceInput];
    [session commitConfiguration];
}

#pragma mark -
#pragma mark - Private methods

+ (AVCaptureDeviceInput *)reverseDeviceInput:(AVCaptureDeviceInput *)deviceInput
{
    //
    // reverse device position
    //
    
    AVCaptureDevicePosition reversePosition;
    
    if ([deviceInput.device position] == AVCaptureDevicePositionFront) {
        reversePosition = AVCaptureDevicePositionBack;
    } else {
        reversePosition = AVCaptureDevicePositionFront;
    }
    
    //
    // find device with reverse position
    //
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *reverseDevice = nil;
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == reversePosition) {
            reverseDevice = device;
            break;
        }
    }

    //
    // reverse device input
    //
    
    return  [AVCaptureDeviceInput deviceInputWithDevice:reverseDevice error:nil];
}

@end

