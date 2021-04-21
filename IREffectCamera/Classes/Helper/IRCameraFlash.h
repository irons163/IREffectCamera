//
//  IRCameraFlash.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IRCameraFlash : NSObject

+ (void)changeModeWithCaptureSession:(AVCaptureSession *)session andButton:(UIButton *)button;
+ (void)flashModeWithCaptureSession:(AVCaptureSession *)session andButton:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
