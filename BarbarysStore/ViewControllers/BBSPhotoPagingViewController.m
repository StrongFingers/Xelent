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
#import "BBSNavigationBar.h"
#import "BBSOfferDetailViewController.h"

@interface BBSPhotoPagingViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, assign) NSInteger tmpIndex;
@end

@implementation BBSPhotoPagingViewController

- (void)viewDidLoad {
    
    self.tmpIndex = self.currentIndex;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self setNeedsStatusBarAppearanceUpdate];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    self.dataSource = self;


    //[self.navigationController setNavigationBarHidden:YES animated:NO];
   // UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    
    //UIBarButtonItem *emptyNavigationBackButton = [[UIBarButtonItem alloc] initWithTitle:@"lal" /style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
    
    /* UIBarButtonItem *backButtonItemButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BACK_BUTTON_DEFAULT_ICON"] style:UIBarButtonItemStyleBordered target:self action:@selector(backTapped:)];*/
    //self.itsANavigationItem.leftBarButtonItem = emptyNavigationBackButton;
    /*[self.itsANavigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat:@"%lu из %lu",self.currentIndex+1,[self.photos count]]];*/
    
    //[newNavBar setItems:@[self.itsANavigationItem]];
    //[self.view addSubview:newNavBar];
    

    
    [self configurePageView];
    DLog(@"%f %f",CGRectGetWidth(self.navigationController.navigationBar.bounds),CGRectGetHeight(self.navigationController.navigationBar.bounds));
    DLog(@"MYSCREEN= %f",CGRectGetWidth(self.view.bounds));
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];


}

- (void) backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingBackButtonWith:(NSInteger)realValue withTheoreticalMax:(NSInteger)theorMaxValue
 {
 NSArray *viewControllerArray = [self.navigationController viewControllers];
 int parentViewControllerIndex = (int)[viewControllerArray count] - 2;
 [[viewControllerArray objectAtIndex:parentViewControllerIndex] setBackBarButtonTitle:[NSString stringWithFormat:@"%lu из %lu",realValue+1,theorMaxValue]];
 }
- (void)configurePageView
{
    BBSPhotoContentViewController *startingViewController = [self viewControllerAtIndex:self.currentIndex];
    NSArray *viewControllers = @[startingViewController];
    [self settingBackButtonWith:self.tmpIndex withTheoreticalMax:[self.photos count]];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (BBSPhotoContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.photos count] == 0) || (index >= [self.photos count])) {
        return nil;
    }
    
    BBSPhotoContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BBSPhotoContentViewController"];


    pageContentViewController.pageIndex = index;
    _currentIndex = index;
    pageContentViewController.imageUrl = self.photos[index];
    
    
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    /*NSUInteger index = ((BBSPhotoContentViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];*/
    

    if (self.currentIndex == 0)
    {
        return nil;
    } else {

        return  [self viewControllerAtIndex:self.currentIndex-1];};
   
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    

    
    if (self.currentIndex == [self.photos count]-1)
        {
        return nil;
        } else {

            return  [self viewControllerAtIndex:self.currentIndex+1];};
    
    
    /*NSUInteger index = ((BBSPhotoContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.photos count]) {
        return nil;
    }*/
    
   // return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed) {
        BBSPhotoContentViewController *currentVC = (BBSPhotoContentViewController *) [pageViewController.viewControllers lastObject];
        self.currentIndex = currentVC.pageIndex;
        self.tmpIndex = currentVC.pageIndex;
        NSArray *viewControllerArray = [self.navigationController viewControllers];
        int parentViewControllerIndex = (int)[viewControllerArray count] - 2;
        [[viewControllerArray objectAtIndex:parentViewControllerIndex] setBackBarButtonTitle:[NSString stringWithFormat:@"%lu из %lu",[self tmpIndex]+1,[self.photos count]]];
        //[self setTitle:[NSString stringWithFormat:@"%ld",(long)currentVC.pageIndex+1]];
        
    }
}

@end
