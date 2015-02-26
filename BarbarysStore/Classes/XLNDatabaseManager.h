//
//  XLNDatabaseManager.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSOffer.h"
#import "BBSCartOffer.h"

@interface XLNDatabaseManager : NSObject

- (void)createDB;
- (void)addOffers:(NSArray *)offers;
- (void)addCategories:(NSArray *)categories;
- (NSArray *)getAllCategories;
- (NSArray *)getOffersByCategoryId:(NSString *)categoryId;
//- (NSArray *)getPicturesForOfferId:(NSString *)offerId;
- (void)addToFavorites:(BBSOffer *)offer;
- (void)removeFromFavorites:(BBSOffer *)offer;
- (NSArray *)getFavorites;
- (void)addToShoppingCart:(BBSCartOffer *)offer;
- (NSArray *)getShoppingCart;
- (NSInteger)countOfRows:(BBSOffer *)offer;
- (BBSCartOffer *)cartOfferById:(NSString *)offerId;

@end
