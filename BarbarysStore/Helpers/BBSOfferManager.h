//
//  OfferManager.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSOfferManager : NSObject

- (id)init;
- (id)initWithOffers:(NSArray *)offers;
- (void)addOffer:(id)offer;
- (void)saveToDB;

+ (NSArray *)parseCategoryOffers:(NSArray *)offerData;

@end
