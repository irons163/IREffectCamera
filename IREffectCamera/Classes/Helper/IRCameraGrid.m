//
//  IRCameraGrid.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCameraGrid.h"

@implementation IRCameraGrid

+ (void)displayGridView:(IRCameraGridView *)gridView
{
    NSInteger newAlpha = ([gridView alpha] == 0.) ? 1. : 0.;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        gridView.alpha = newAlpha;
    } completion:NULL];
}

@end

