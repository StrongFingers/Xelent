//
//  BBSOfferDetailViewController.h
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 8/26/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPPSignInButton.h>
#import <GPPSignIn.h>
#import "BBSOffer.h"

@interface BBSOfferDetailViewController : UIViewController 

@property (nonatomic, strong) NSString *offerId;
@property (nonatomic, strong) NSString *selectedColor;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, assign) BOOL fromFavorites;
@property (nonatomic, assign) BOOL fromShoppingCart;
- (void)updateOffer:(BBSOffer *)offer;
- (void)setBackBarButtonTitle:(NSString *)inputString;
@end
