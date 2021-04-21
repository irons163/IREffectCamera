//
//  IRCameraFunctions.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCameraFunctions.h"

NSString *IRLocalizedString(NSString* key) {
    static NSBundle *bundle = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        NSString *path = [[NSBundle bundleForClass:NSClassFromString(@"IRCameraViewController")] pathForResource:@"IRCameraViewController" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    });
    return [bundle localizedStringForKey:key value:key table:nil];
}

@implementation IRCameraFunctions

@end
