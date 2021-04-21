//
//  ViewController.m
//  demo
//
//  Created by irons on 2021/4/21.
//

#import "ViewController.h"
#import "FilterViewController.h"
#import <IREffectCamera/IREffectCamera.h>

@interface ViewController ()<IRCameraDelegate> {
    BOOL useCustomizePhotoProcessingView;
    FilterViewController *vc;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self addNewPhotoButtonClick:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(vc.image) {
        self.imageView.image = vc.image;
    }
}

- (IBAction)addNewPhotoButtonClick:(id)sender {
    /*
    // set custom tint color
    [IRCameraColor setTintColor: [UIColor whiteColor]];
    
    // save image to album
    [IRCamera setOption:kIRCameraOptionSaveImageToAlbum value:@YES];
    
    // use the original image aspect instead of square
    [IRCamera setOption:kIRCameraOptionUseOriginalAspect value:@YES];
    
    // hide switch camera button
    [IRCamera setOption:kIRCameraOptionHiddenToggleButton value:@YES];
    
    // hide album button
    [IRCamera setOption:kIRCameraOptionHiddenAlbumButton value:@YES];
    
    // hide filter button
    [IRCamera setOption:kIRCameraOptionHiddenFilterButton value:@YES];
    */
    
    useCustomizePhotoProcessingView = NO;
    IRCameraNavigationController *cameraViewController = [IRCameraNavigationController newWithCameraDelegate:self];
    cameraViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:cameraViewController animated:YES completion:nil];
}

- (IBAction)addNewPhotoWithCustomPhotoProcessingButtonClick:(id)sender {
    useCustomizePhotoProcessingView = YES;
    IRCameraNavigationController *cameraViewController = [IRCameraNavigationController newWithCameraDelegate:self];
    cameraViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:cameraViewController animated:YES completion:nil];
}

#pragma mark - IRCameraDelegate

- (void)cameraDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealWithImage:(UIImage * _Nonnull)image {
    if (!useCustomizePhotoProcessingView) {
        vc = nil;
        self.imageView.image = image;
        [self dismiss];
        return;
    }
    
    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterViewController"];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.image = image;
    [self dismiss];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)cameraDidTakePhoto:(UIImage *)image
{
    [self dealWithImage:image];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    [self dealWithImage:image];
}

- (void)dismiss {
    if(self.navigationController)
        [(UINavigationController *)self.navigationController dismissViewControllerAnimated:YES completion:nil];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)customizePhotoProcessingView {
    return useCustomizePhotoProcessingView;
}

@end

