//
//  IRCameraViewController.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <IREffectCamera/IRAssetsLibrary.h>
#import <IREffectCamera/IRCamera.h>
#import <IREffectCamera/IRCameraColor.h>
#import <IREffectCamera/IRCameraNavigationController.h>
#import <IREffectCamera/IRAssetImageFile.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IRCameraViewControllerDelegate <NSObject>

- (void)didFinishPickingImage:(UIImage*)image;

@end

@interface IRCameraViewController : UIViewController

@property (weak) id<IRCameraDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
