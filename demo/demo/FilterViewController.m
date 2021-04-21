//
//  FilterViewController.m
//  demo
//
//  Created by Phil on 2019/12/24.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "FilterViewController.h"
#import <GPUImage/GPUImage.h>

@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *filterButton1;
@property (weak, nonatomic) IBOutlet UIButton *filterButton2;
@property (weak, nonatomic) IBOutlet UIButton *filterButton3;
@property (weak, nonatomic) IBOutlet UIButton *filterButton4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self.image;
    
    CGRect rect = CGRectMake(0,0,75,75);
    UIGraphicsBeginImageContext( rect.size );
    [self.image drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.filterButton1 setBackgroundImage:[self imageWithSepiafilter:thumbnail] forState:UIControlStateNormal];
    [self.filterButton2 setBackgroundImage:[self imageWithBrightnessFilter:thumbnail] forState:UIControlStateNormal];
    [self.filterButton3 setBackgroundImage:[self imageWithHazeFilter:thumbnail] forState:UIControlStateNormal];
    [self.filterButton4 setBackgroundImage:[self imageWithSketchFilter:thumbnail] forState:UIControlStateNormal];
}

- (UIImage *)imageWithSepiafilter:(UIImage *)originImage {
    GPUImageFilter *imageFilter = [[GPUImageSepiaFilter alloc] init];
    return [imageFilter imageByFilteringImage:originImage];
}

- (UIImage *)imageWithBrightnessFilter:(UIImage *)originImage {
    GPUImageFilter *imageFilter = [[GPUImageBrightnessFilter alloc] init];
    return [imageFilter imageByFilteringImage:originImage];
}

- (UIImage *)imageWithHazeFilter:(UIImage *)originImage {
    GPUImageFilter *imageFilter = [[GPUImageHazeFilter alloc] init];
    return [imageFilter imageByFilteringImage:originImage];
}

- (UIImage *)imageWithSketchFilter:(UIImage *)originImage {
    GPUImageFilter *imageFilter = [[GPUImageSketchFilter alloc] init];
    return [imageFilter imageByFilteringImage:originImage];
}

- (IBAction)filterButton1Click:(id)sender {
    self.imageView.image = [self imageWithSepiafilter:self.image];
}

- (IBAction)filterButton2Click:(id)sender {
    self.imageView.image = [self imageWithBrightnessFilter:self.image];
}

- (IBAction)filterButton3Click:(id)sender {
    self.imageView.image = [self imageWithHazeFilter:self.image];
}

- (IBAction)filterButton4Click:(id)sender {
    self.imageView.image = [self imageWithSketchFilter:self.image];
}

- (IBAction)closeButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonClick:(id)sender {
    self.image = self.imageView.image;
    [self closeButtonClick:nil];
}

@end
