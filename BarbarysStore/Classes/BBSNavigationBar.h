//
//  BBSNavigationBar.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/9/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSNavigationBar : UINavigationBar
@property (nonatomic, strong) UINavigationItem *navigationItem;
-(void) copyNavigationItem:(UINavigationItem *)inputNavItem;
@end
