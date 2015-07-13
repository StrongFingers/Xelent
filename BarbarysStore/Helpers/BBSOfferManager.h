//
//  OfferManager.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBSOffer.h"
#import "BBSCartOffer.h"
#import "BBSHistoryItem.h"

typedef enum : NSUInteger {
    offerAdd,
    offerDelete,
    offerUpdate,
} offerState;

@interface BBSOfferManager : NSObject

- (id)init;
- (id)initWithOffers:(NSArray *)offers;
- (void)addOffer:(id)offer;
- (void)updateOfferInFavorites:(BBSOffer *)offer state:(offerState)state;
- (NSInteger)countOfRows:(BBSOffer *)offer;
- (NSArray *)getFavorites;
- (NSArray *)getShoppingCart;
- (void)removeFromShoppingCart:(BBSCartOffer *)offer;
- (void)addToShoppingCart:(BBSCartOffer *)offer;
- (void)addToHistory:(BBSHistoryItem *)historyItem;
- (NSArray *)loadFromHistory;

+ (NSArray *)parseCategoryOffers:(NSArray *)offerData;
+ (BBSOffer *)parseDetailOffer:(NSDictionary *)offerData;

@end
