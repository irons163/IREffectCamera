//
//  IRAssetImageFile.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRAssetImageFile.h"

@implementation IRAssetImageFile

- (instancetype)initWithPath:(NSString *)path image:(UIImage *)image {
    self = [self init];
    
    if (self) {
        self.path = path;
        self.image = image;
    }
    
    return self;
}

@end
