//
//  UIImage+CameraFilters.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage(CameraFilters)

- (UIImage *)curveFilter;
- (UIImage *)saturateImage:(CGFloat)saturation withContrast:(CGFloat)contrast;
- (UIImage *)vignetteWithRadius:(CGFloat)radius intensity:(CGFloat)intensity;

@end

NS_ASSUME_NONNULL_END
