//
//  IRCameraShot.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IRCameraShot : NSObject

+ (void)takePhotoCaptureView:(UIView *)captureView
stillImageOutput:(AVCaptureStillImageOutput *)stillImageOutput
videoOrientation:(AVCaptureVideoOrientation)videoOrientation
        cropSize:(CGSize)cropSize
      completion:(void (^)(UIImage *photo))completion;

@end

NS_ASSUME_NONNULL_END
