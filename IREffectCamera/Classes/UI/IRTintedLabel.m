//
//  IRTintedLabel.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//
//  Created by Mike Sprague on 3/30/15.
//  Copyright (c) 2015 Tudo Gostoso Internet. All rights reserved.
//

#import "IRTintedLabel.h"
#import "IRCameraColor.h"

@interface IRTintedLabel ()

- (void)updateTintIfNeeded;

@end

@implementation IRTintedLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self updateTintIfNeeded];
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
    [self updateTintIfNeeded];
}

- (void)updateTintIfNeeded
{
    if(self.tintColor != [IRCameraColor tintColor] || self.textColor != self.tintColor) {
        [self setTintColor:[IRCameraColor tintColor]];
        self.textColor = self.tintColor;
    }
}

@end
