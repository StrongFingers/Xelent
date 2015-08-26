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
#import "BBSHistoryItem.h"

@interface XLNDatabaseManager : NSObject

@property (nonatomic, strong) BBSOffer *offer;

- (void)createDB;
- (NSArray *)getAllCategories;
- (void)getOfferToFavoriteById:(BBSOffer *)offer;
- (void)addToFavorite;
- (void)removeFromFavorites:(BBSOffer *)offer;
- (void)updateFavorite:(BBSOffer *)offer;
- (NSArray *)getFavorites;
- (void)addToShoppingCart:(BBSCartOffer *)offer;
- (void)removeFromShoppingCart:(BBSCartOffer *)offer;
- (NSArray *)getShoppingCart;
- (NSInteger)countOfRows:(BBSOffer *)offer;
- (BBSCartOffer *)cartOfferById:(NSString *)offerId;
- (void)addToHistory:(BBSHistoryItem *)historyItem;
- (NSArray *)loadFromHistory;
- (BOOL) isOfferInShoppingCart:(BBSOffer*)offer;


@end
