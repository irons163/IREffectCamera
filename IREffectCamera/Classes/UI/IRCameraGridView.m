//
//  IRCameraGridView.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCameraGridView.h"
#import "IRCameraColor.h"

@interface IRCameraGridView ()

- (void)setup;

@end



@implementation IRCameraGridView

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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, [IRCameraColor.grayColor colorWithAlphaComponent:.7].CGColor);
    
    CGFloat columnWidth = self.frame.size.width / (self.numberOfColumns + 1.0);
    CGFloat rowHeight = self.frame.size.height / (self.numberOfRows + 1.0);
    
    for (NSUInteger i = 1; i <= self.numberOfColumns; i++) {
        CGPoint startPoint;
        startPoint.x = columnWidth * i;
        startPoint.y = 0.0f;

        CGPoint endPoint;
        endPoint.x = startPoint.x;
        endPoint.y = self.frame.size.height;
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }
 
    for (NSUInteger i = 1; i <= self.numberOfRows; i++) {
        CGPoint startPoint;
        startPoint.x = 0.0f;
        startPoint.y = rowHeight * i;

        CGPoint endPoint;
        endPoint.x = self.frame.size.width;
        endPoint.y = startPoint.y;
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }
}

#pragma mark -
#pragma mark - Private methods

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.lineWidth = .8;
}

@end

