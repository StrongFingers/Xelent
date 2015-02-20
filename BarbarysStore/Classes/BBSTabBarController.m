//
//  BBSTabBarController.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSTabBarController.h"

#import "UIImage+Alpha.h"
#import <SWRevealViewController.h>

@interface BBSTabBarController ()

@end

@implementation BBSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[[self revealViewController] panGestureRecognizer];
    UIImage* tabBarBackground = [self imageFromColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBackgroundImage:[tabBarBackground imageByApplyingAlpha:0.9]];
    [[UITabBar appearance] setShadowImage:[self imageFromColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 35;
    tabFrame.origin.y = self.view.frame.size.height - 35;
    self.tabBar.frame = tabFrame;
}

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    
}

@end
