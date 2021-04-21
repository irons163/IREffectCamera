//
//  IRCameraAuthorizationViewController.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCameraAuthorizationViewController.h"
#import "IRCameraFunctions.h"

@interface IRCameraAuthorizationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *step1Label;
@property (weak, nonatomic) IBOutlet UILabel *step2Label;
@property (weak, nonatomic) IBOutlet UILabel *step3Label;
@property (weak, nonatomic) IBOutlet UILabel *step4Label;

- (IBAction)closeTapped;

@end



@implementation IRCameraAuthorizationViewController

- (instancetype)init
{
    return [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle bundleForClass:self.class]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _titleLabel.text = IRLocalizedString(@"IRCameraViewController-Title");
    _subtitleLabel.text = IRLocalizedString(@"IRCameraViewController-Subtitle");
    _step1Label.text = IRLocalizedString(@"IRCameraViewController-Step1");
    _step2Label.text = IRLocalizedString(@"IRCameraViewController-Step2");
    _step3Label.text = IRLocalizedString(@"IRCameraViewController-Step3");
    _step4Label.text = IRLocalizedString(@"IRCameraViewController-Step4");
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark - Actions

- (IBAction)closeTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
