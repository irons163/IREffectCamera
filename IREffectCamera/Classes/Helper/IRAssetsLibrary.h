//
//  IRAssetsLibrary.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "IRAssetImageFile.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^IRAssetsResultCompletion)(NSURL *assetURL);
typedef void(^IRAssetsFailureCompletion)(NSError* error);
typedef void(^IRAssetsLoadImagesCompletion)(NSArray *items, NSError *error);

@interface IRAssetsLibrary : ALAssetsLibrary

+ (instancetype) new __attribute__
((unavailable("[+new] is not allowed, use [+defaultAssetsLibrary]")));

- (instancetype) init __attribute__
((unavailable("[-init] is not allowed, use [+defaultAssetsLibrary]")));

+ (IRAssetsLibrary *)defaultAssetsLibrary;

- (void)deleteFile:(IRAssetImageFile *)file;

- (NSArray *)loadImagesFromDocumentDirectory;
- (void)loadImagesFromAlbum:(NSString *)albumName withCallback:(IRAssetsLoadImagesCompletion)callback;

- (void)saveImage:(UIImage *)image resultBlock:(IRAssetsResultCompletion)resultBlock failureBlock:(IRAssetsFailureCompletion)failureBlock;
- (void)saveImage:(UIImage *)image withAlbumName:(NSString *)albumName resultBlock:(IRAssetsResultCompletion)resultBlock failureBlock:(IRAssetsFailureCompletion)failureBlock;
- (void)saveJPGImageAtDocumentDirectory:(UIImage *)image resultBlock:(IRAssetsResultCompletion)resultBlock failureBlock:(IRAssetsFailureCompletion)failureBlock;

@end

NS_ASSUME_NONNULL_END
