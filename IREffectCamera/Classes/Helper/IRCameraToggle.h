//
//  IRCameraToggle.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IRCameraToggle : NSObject

+ (void)toogleWithCaptureSession:(AVCaptureSession *)session;

@end

NS_ASSUME_NONNULL_END
