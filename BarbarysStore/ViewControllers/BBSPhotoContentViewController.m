//
//  BBSPhotoItemViewController.m
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 8/26/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSPhotoContentViewController.h"

#import <UIImageView+WebCache.h>

@interface BBSPhotoContentViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (nonatomic, assign) CGFloat zoomScale;

@end

@implementation BBSPhotoContentViewController

- (void)viewDidLoad {
    self.zoomScale = 2.2;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    self.imageScrollView.minimumZoomScale = 1.0;
    self.imageScrollView.maximumZoomScale = 6.0;
    self.imageScrollView.contentSize = self.mainImageView.frame.size;
    self.imageScrollView.delegate = self;
    self.navigationController.hidesBarsOnTap = YES;
    
    //implement the dooble tap zoom
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.imageScrollView addGestureRecognizer:doubleTap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    
    return self.mainImageView;
}
-(void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer {
    //Zoom without touch coordinates
 /*   if (self.imageScrollView.zoomScale > self.imageScrollView.minimumZoomScale) {
        [self.imageScrollView setZoomScale:self.imageScrollView.minimumZoomScale animated:YES];
    } else (
            [self.imageScrollView setZoomScale:self.zoomScale animated:YES]);
*/
    //Zoom with touch coordinates
    if (self.imageScrollView.zoomScale > self.imageScrollView.minimumZoomScale) {
        [self.imageScrollView setZoomScale:self.imageScrollView.minimumZoomScale animated:YES];
    } else {
        CGPoint touch =[gestureRecognizer locationInView:gestureRecognizer.view];
        
        CGSize scrollViewSize = self.imageScrollView.bounds.size;
        
        CGFloat w = scrollViewSize.width / self.zoomScale;
        CGFloat h = scrollViewSize.height / self.zoomScale;
        CGFloat x = touch.x - (w/2.0);
        CGFloat y = touch.y - (h/2.0);
        
        CGRect rectToZoom = CGRectMake(x, y, w, h);
        [self.imageScrollView zoomToRect:rectToZoom animated:YES];
        }
}
@end
