//
//  BBSPhotoPagingViewController.h
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 8/26/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSPhotoPagingViewController : UIPageViewController

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) NSInteger currentIndex;

@end
