//
//  BBSPhotoItemViewController.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/17/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSPhotoContentViewController.h"

#import <UIImageView+WebCache.h>

@interface BBSPhotoContentViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@end

@implementation BBSPhotoContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    self.imageScrollView.minimumZoomScale = 1.0;
    self.imageScrollView.maximumZoomScale = 6.0;
    self.imageScrollView.contentSize = self.mainImageView.frame.size;
    self.imageScrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.mainImageView;
}

@end
