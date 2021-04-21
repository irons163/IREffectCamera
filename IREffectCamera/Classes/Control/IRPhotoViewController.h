//
//  IRPhotoViewController.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRCamera.h"

NS_ASSUME_NONNULL_BEGIN

@interface IRPhotoViewController : UIViewController

+ (instancetype)new __attribute__
((unavailable("[+new] is not allowed, use [+newWithDelegate:photo:]")));

- (instancetype) init __attribute__
((unavailable("[-init] is not allowed, use [+newWithDelegate:photo:]")));

+ (instancetype)newWithDelegate:(id<IRCameraDelegate>)delegate photo:(UIImage *)photo;

- (void)setAlbumPhoto:(BOOL)isAlbumPhoto;

@end

NS_ASSUME_NONNULL_END
