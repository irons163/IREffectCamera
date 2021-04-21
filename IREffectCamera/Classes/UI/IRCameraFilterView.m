//
//  IRCameraFilterView.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCameraFilterView.h"



@interface IRCameraFilterView ()

- (void)setup;

@end



@implementation IRCameraFilterView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

#pragma mark -
#pragma mark - Public methods

- (void)addToView:(UIView *)view aboveView:(UIView *)aboveView
{
    CGRect frame = self.frame;
    frame.origin.y = CGRectGetMaxY(view.frame) - CGRectGetHeight(aboveView.frame);
    self.frame = frame;
    
    [view addSubview:self];
    
    frame.origin.y -= CGRectGetHeight(self.frame);
    
    [UIView animateWithDuration:.5 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {}];
}

- (void)removeFromSuperviewAnimated
{
    CGRect frame = self.frame;
    frame.origin.y += CGRectGetHeight(self.frame);
    
    [UIView animateWithDuration:.5 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark - Private methods

- (void)setup
{
    CGRect frame = self.frame;
    frame.size.width = CGRectGetWidth([UIScreen.mainScreen applicationFrame]);
    self.frame = frame;
}

@end

