//
//  IRCameraColor.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCameraColor.h"

static UIColor *staticTintColor = nil;
@interface IRCameraColor()

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end


@implementation IRCameraColor

+ (void)setTintColor:(UIColor*)tintColor {
    staticTintColor = tintColor;
}

+ (UIColor *)grayColor
{
    return [self colorWithRed:200 green:200 blue:200];
}

+ (UIColor *)tintColor
{
    return staticTintColor != nil ? staticTintColor : [self colorWithRed:255 green:91 blue:1];
}

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    CGFloat divisor = 255.f;
    return [self colorWithRed:red/divisor green:green/divisor blue:blue/divisor alpha:1];
}

@end
