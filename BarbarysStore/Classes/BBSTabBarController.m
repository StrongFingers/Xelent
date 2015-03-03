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
    [[self revealViewController] tapGestureRecognizer];
    UIImage* tabBarBackground = [self imageFromColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBackgroundImage:[tabBarBackground imageByApplyingAlpha:0.95]];
    [[UITabBar appearance] setShadowImage:[self imageFromColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]]];
    UITabBarItem *item1 = self.tabBar.items[0];
    UITabBarItem *item2 = self.tabBar.items[1];
    UITabBarItem *item3 = self.tabBar.items[2];
    UITabBarItem *item4 = self.tabBar.items[3];
    UITabBarItem *item5 = self.tabBar.items[4];
    
    [item1 setImage:[[UIImage imageNamed:@"homeTabIconUnactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setSelectedImage:[[UIImage imageNamed:@"homeTabIconActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setImage:[[UIImage imageNamed:@"catalogTabIconUnactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"catalogTabIconActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setImage:[[UIImage imageNamed:@"favoritesTabIconUnactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setSelectedImage:[[UIImage imageNamed:@"favoritesTabIconActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setImage:[[UIImage imageNamed:@"cartTabIconUnactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"cartTabIconActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item5 setImage:[[UIImage imageNamed:@"profileTabIconUnactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item5 setSelectedImage:[[UIImage imageNamed:@"profileTabIconActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    item1.imageInsets = imageInsets;
    item2.imageInsets = imageInsets;
    item3.imageInsets = imageInsets;
    item4.imageInsets = imageInsets;
    item5.imageInsets = imageInsets;
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
