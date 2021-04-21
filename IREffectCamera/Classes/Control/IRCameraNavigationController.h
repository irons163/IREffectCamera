//
//  IRCameraNavigationController.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRCamera.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IRCameraNavigationControllerDelegate <NSObject>

- (void)didFinishPickingImage:(UIImage*)image;

@end

@interface IRCameraNavigationController : UINavigationController

+ (instancetype)new __attribute__
((unavailable("[+new] is not allowed, use [+newWithCameraDelegate:]")));

- (instancetype) init __attribute__
((unavailable("[-init] is not allowed, use [+newWithCameraDelegate:]")));

- (id)initWithCoder:(NSCoder *)aDecoder __attribute__
((unavailable("[-initWithCoder:] is not allowed, use [+newWithCameraDelegate:]")));

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass __attribute__
((unavailable("[-initWithNavigationBarClass:toolbarClass:] is not allowed, use [+newWithCameraDelegate:]")));

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil __attribute__
((unavailable("[-initWithNibName:bundle:] is not allowed, use [+newWithCameraDelegate:]")));

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController __attribute__
((unavailable("[-initWithRootViewController:] is not allowed, use [+newWithCameraDelegate:]")));

+ (instancetype)newWithCameraDelegate:(id<IRCameraDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
