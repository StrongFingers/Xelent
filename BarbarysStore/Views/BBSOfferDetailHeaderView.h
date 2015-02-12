//
//  BBSOfferDetailHeaderView.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/12/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSAbstractButton.h"

@interface BBSOfferDetailHeaderView : BBSAbstractButtonImpl

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL expanded;

- (BBSOfferDetailHeaderView *)headerWithTitle:(NSString *)title index:(NSInteger)index;

@end
