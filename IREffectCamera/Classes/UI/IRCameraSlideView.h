//
//  IRCameraSlideView.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@import UIKit;

@protocol IRCameraSlideViewProtocol;



@interface IRCameraSlideView : UIView

+ (void)showSlideUpView:(IRCameraSlideView *)slideUpView
          slideDownView:(IRCameraSlideView *)slideDownView
                 atView:(UIView *)view
             completion:(void (^)(void))completion;

+ (void)hideSlideUpView:(IRCameraSlideView *)slideUpView
          slideDownView:(IRCameraSlideView *)slideDownView
                 atView:(UIView *)view
             completion:(void (^)(void))completion;

@end



@protocol IRCameraSlideViewProtocol <NSObject>

- (CGFloat)initialPositionWithView:(UIView *)view;
- (CGFloat)finalPosition;

@end

NS_ASSUME_NONNULL_END
