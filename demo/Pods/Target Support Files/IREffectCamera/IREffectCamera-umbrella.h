#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIImage+CameraFilters.h"
#import "IRCameraAuthorizationViewController.h"
#import "IRCameraNavigationController.h"
#import "IRCameraViewController.h"
#import "IRPhotoViewController.h"
#import "IRAlbum.h"
#import "IRAssetsLibrary.h"
#import "IRCamera.h"
#import "IRCameraColor.h"
#import "IRCameraFlash.h"
#import "IRCameraFocus.h"
#import "IRCameraFunctions.h"
#import "IRCameraGrid.h"
#import "IRCameraShot.h"
#import "IRCameraToggle.h"
#import "IREffectCamera.h"
#import "IRAssetImageFile.h"
#import "IRCameraFilterView.h"
#import "IRCameraFocusView.h"
#import "IRCameraGridView.h"
#import "IRCameraSlideDownView.h"
#import "IRCameraSlideUpView.h"
#import "IRCameraSlideView.h"
#import "IRTintedButton.h"
#import "IRTintedLabel.h"
#import "UIImage+Bundle.h"
#import "Utility.h"

FOUNDATION_EXPORT double IREffectCameraVersionNumber;
FOUNDATION_EXPORT const unsigned char IREffectCameraVersionString[];

