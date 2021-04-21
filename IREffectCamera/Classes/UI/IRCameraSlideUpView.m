//
//  IRCameraSlideUpView.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCameraSlideUpView.h"

@interface IRCameraSlideUpView () <IRCameraSlideViewProtocol>

@end

@implementation IRCameraSlideUpView

#pragma mark -
#pragma mark - IRCameraSlideViewProtocol

- (CGFloat)initialPositionWithView:(UIView *)view
{
    return 0;
}

- (CGFloat)finalPosition
{
    return -CGRectGetHeight(self.frame);
}

@end
