//
//  IRPhotoViewController.m
//  IRCameraViewController
//
//  Created by Phil on 2019/9/20.
//  Copyright © 2019 Phil. All rights reserved.
//

@import AssetsLibrary;
#import "IRPhotoViewController.h"
#import "IRAssetsLibrary.h"
#import "IRCameraColor.h"
#import "IRCameraFilterView.h"
#import "UIImage+CameraFilters.h"
#import "IRTintedButton.h"
#import "UIImage+Bundle.h"

static NSString* const kIRCacheSatureKey = @"IRCacheSatureKey";
static NSString* const kIRCacheCurveKey = @"IRCacheCurveKey";
static NSString* const kIRCacheVignetteKey = @"IRCacheVignetteKey";



@interface IRPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet IRCameraFilterView *filterView;
@property (strong, nonatomic) IBOutlet UIButton *defaultFilterButton;
@property (weak, nonatomic) IBOutlet IRTintedButton *filterWandButton;
@property (weak, nonatomic) IBOutlet IRTintedButton *cancelButton;
@property (weak, nonatomic) IBOutlet IRTintedButton *confirmButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (weak) id<IRCameraDelegate> delegate;
@property (strong, nonatomic) UIView *detailFilterView;
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) NSCache *cachePhoto;
@property (nonatomic) BOOL albumPhoto;

- (IBAction)backTapped;
- (IBAction)confirmTapped;
- (IBAction)filtersTapped;

- (IBAction)defaultFilterTapped:(UIButton *)button;
- (IBAction)satureFilterTapped:(UIButton *)button;
- (IBAction)curveFilterTapped:(UIButton *)button;
- (IBAction)vignetteFilterTapped:(UIButton *)button;

- (void)addDetailViewToButton:(UIButton *)button;
+ (instancetype)newController;

@end



@implementation IRPhotoViewController

+ (instancetype)newWithDelegate:(id<IRCameraDelegate>)delegate photo:(UIImage *)photo
{
    IRPhotoViewController *viewController = [IRPhotoViewController newController];
    
    if (viewController) {
        viewController.delegate = delegate;
        viewController.photo = photo;
        viewController.cachePhoto = [[NSCache alloc] init];
    }
    
    return viewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (CGRectGetHeight([[UIScreen mainScreen] bounds]) <= 480) {
        _topViewHeight.constant = 0;
    }
    
    _photoView.clipsToBounds = YES;
    _photoView.image = _photo;
    
    [_cancelButton setImage:[UIImage imageNamedForCurrentBundle:@"CameraBack"] forState:UIControlStateNormal];
    [_confirmButton setImage:[UIImage imageNamedForCurrentBundle:@"CameraShot"] forState:UIControlStateNormal];
    [_filterWandButton setImage:[UIImage imageNamedForCurrentBundle:@"CameraFilter"] forState:UIControlStateNormal];

    if ([[IRCamera getOption:kIRCameraOptionHiddenFilterButton] boolValue] == YES) {
        _filterWandButton.hidden = YES;
    }
    
    [self addDetailViewToButton:_defaultFilterButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark -
#pragma mark - Controller actions

- (IBAction)backTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmTapped
{
    if ( [_delegate respondsToSelector:@selector(cameraWillTakePhoto)]) {
        [_delegate cameraWillTakePhoto];
    }
    
    if ([_delegate respondsToSelector:@selector(cameraDidTakePhoto:)]) {
        _photo = _photoView.image;
        
        if (_albumPhoto) {
            [_delegate cameraDidSelectAlbumPhoto:_photo];
        } else {
            [_delegate cameraDidTakePhoto:_photo];
        }
        
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        IRAssetsLibrary *library = [IRAssetsLibrary defaultAssetsLibrary];
        
        void (^saveJPGImageAtDocumentDirectory)(UIImage *) = ^(UIImage *photo) {
            [library saveJPGImageAtDocumentDirectory:_photo resultBlock:^(NSURL *assetURL) {
                if ([_delegate respondsToSelector:@selector(cameraDidSavePhotoAtPath:)]) {
                    [_delegate cameraDidSavePhotoAtPath:assetURL];
                }
            } failureBlock:^(NSError *error) {
                if ([_delegate respondsToSelector:@selector(cameraDidSavePhotoWithError:)]) {
                    [_delegate cameraDidSavePhotoWithError:error];
                }
            }];
        };
        
        if ([[IRCamera getOption:kIRCameraOptionSaveImageToAlbum] boolValue] && status != ALAuthorizationStatusDenied) {
            [library saveImage:_photo resultBlock:^(NSURL *assetURL) {
                if ([_delegate respondsToSelector:@selector(cameraDidSavePhotoAtPath:)]) {
                    [_delegate cameraDidSavePhotoAtPath:assetURL];
                }
            } failureBlock:^(NSError *error) {
                saveJPGImageAtDocumentDirectory(_photo);
            }];
        } else {
            if ([_delegate respondsToSelector:@selector(cameraDidSavePhotoAtPath:)]) {
                saveJPGImageAtDocumentDirectory(_photo);
            }
        }
    }
}

- (IBAction)filtersTapped
{
    if ([_filterView isDescendantOfView:self.mainView]) {
        [_filterView removeFromSuperviewAnimated];
    } else {
        [_filterView addToView:self.mainView aboveView:_bottomView];
        [self.view sendSubviewToBack:_filterView];
        [self.view sendSubviewToBack:_photoView];
    }
}

#pragma mark -
#pragma mark - Filter view actions

- (IBAction)defaultFilterTapped:(UIButton *)button
{
    [self addDetailViewToButton:button];
    _photoView.image = _photo;
}

- (IBAction)satureFilterTapped:(UIButton *)button
{
    [self addDetailViewToButton:button];
    
    if ([_cachePhoto objectForKey:kIRCacheSatureKey]) {
        _photoView.image = [_cachePhoto objectForKey:kIRCacheSatureKey];
    } else {
        [_cachePhoto setObject:[_photo saturateImage:1.8 withContrast:1] forKey:kIRCacheSatureKey];
        _photoView.image = [_cachePhoto objectForKey:kIRCacheSatureKey];
    }
    
}

- (IBAction)curveFilterTapped:(UIButton *)button
{
    [self addDetailViewToButton:button];
    
    if ([_cachePhoto objectForKey:kIRCacheCurveKey]) {
        _photoView.image = [_cachePhoto objectForKey:kIRCacheCurveKey];
    } else {
        [_cachePhoto setObject:[_photo curveFilter] forKey:kIRCacheCurveKey];
        _photoView.image = [_cachePhoto objectForKey:kIRCacheCurveKey];
    }
}

- (IBAction)vignetteFilterTapped:(UIButton *)button
{
    [self addDetailViewToButton:button];
    
    if ([_cachePhoto objectForKey:kIRCacheVignetteKey]) {
        _photoView.image = [_cachePhoto objectForKey:kIRCacheVignetteKey];
    } else {
        [_cachePhoto setObject:[_photo vignetteWithRadius:0 intensity:6] forKey:kIRCacheVignetteKey];
        _photoView.image = [_cachePhoto objectForKey:kIRCacheVignetteKey];
    }
}


#pragma mark -
#pragma mark - Private methods

- (void)addDetailViewToButton:(UIButton *)button
{
    [_detailFilterView removeFromSuperview];
    
    CGFloat height = 2.5;
    
    CGRect frame = button.frame;
    frame.size.height = height;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(button.frame) - height;
    
    _detailFilterView = [[UIView alloc] initWithFrame:frame];
    _detailFilterView.backgroundColor = [IRCameraColor tintColor];
    _detailFilterView.userInteractionEnabled = NO;
    
    [button addSubview:_detailFilterView];
}

+ (instancetype)newController
{
    return [[self alloc] initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle bundleForClass:self.class]];
}

@end
