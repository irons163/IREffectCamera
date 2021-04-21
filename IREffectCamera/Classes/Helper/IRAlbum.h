//
//  IRAlbum.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IRAlbum : NSObject

+ (BOOL)isAvailable;

+ (UIImage *)imageWithMediaInfo:(NSDictionary *)info;
+ (UIImagePickerController *)imagePickerControllerWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
