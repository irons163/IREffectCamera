//
//  IRAssetImageFile.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IRAssetImageFile : NSObject

@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *title;

- (instancetype)initWithPath:(NSString *)path image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
