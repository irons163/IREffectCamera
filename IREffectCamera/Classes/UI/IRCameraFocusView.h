//
//  IRCameraFocusView.h
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define IRCameraFocusSize 50

@interface IRCameraFocusView : UIView

- (void)startAnimation;
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
