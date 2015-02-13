//
//  BBSSideMenuHeaderView.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/13/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSAbstractButton.h"

@interface BBSSideMenuHeaderView : BBSAbstractButtonImpl

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL expanded;

- (BBSSideMenuHeaderView *)headerWithTitle:(NSString *)title index:(NSInteger)index;


@end
