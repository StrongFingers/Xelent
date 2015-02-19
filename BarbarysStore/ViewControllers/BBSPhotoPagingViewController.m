//
//  BBSPhotoPagingViewController.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/17/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSPhotoPagingViewController.h"
#import "BBSPhotoContentViewController.h"
#import "BBSOffer.h"

@interface BBSPhotoPagingViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation BBSPhotoPagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.dataSource = self;
    [self configurePageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configurePageView
{
    BBSPhotoContentViewController *startingViewController = [self viewControllerAtIndex:self.currentIndex];
    NSArray *viewControllers = @[startingViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (BBSPhotoContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.photos count] == 0) || (index >= [self.photos count])) {
        return nil;
    }
    
    BBSPhotoContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BBSPhotoContentViewController"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.imageUrl = ((PictureUrl *)self.photos[index]).url;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((BBSPhotoContentViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((BBSPhotoContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.photos count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed) {
        BBSPhotoContentViewController *currentVC = (BBSPhotoContentViewController *) [pageViewController.viewControllers lastObject];
        self.currentIndex = currentVC.pageIndex;
    }
}

@end
