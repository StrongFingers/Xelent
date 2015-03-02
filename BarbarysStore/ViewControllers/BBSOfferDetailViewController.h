//
//  BBSOfferDetailViewController.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/10/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBSOffer.h"

@interface BBSOfferDetailViewController : UIViewController

@property (nonatomic, strong) NSString *offerId;
@property (nonatomic, strong) NSString *selectedColor;
@property (nonatomic, assign) BOOL fromFavorites;
@property (nonatomic, assign) BOOL fromShoppingCart;

- (void)updateOffer:(BBSOffer *)offer;

@end
