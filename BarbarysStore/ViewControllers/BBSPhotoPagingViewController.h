//
//  BBSPhotoPagingViewController.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/17/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm.h>

@interface BBSPhotoPagingViewController : UIPageViewController

@property (nonatomic, strong) RLMArray *photos;
@property (nonatomic, assign) NSInteger currentIndex;

@end
