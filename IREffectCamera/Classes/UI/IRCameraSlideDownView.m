//
//  IRCameraSlideDownView.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCameraSlideDownView.h"

@interface IRCameraSlideDownView () <IRCameraSlideViewProtocol>

@end



@implementation IRCameraSlideDownView

#pragma mark -
#pragma mark - IRCameraSlideViewProtocol

- (CGFloat)initialPositionWithView:(UIView *)view
{
    return CGRectGetHeight(view.frame)/2;
}

- (CGFloat)finalPosition
{
    return CGRectGetMaxY(self.frame);
}

@end
