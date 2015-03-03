//
//  BBSOfferCollectionViewCell.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSOffer.h"

@protocol BBSOfferCellDelegate <NSObject>

@optional
- (void)refreshOffer:(BBSOffer *)offer cell:(id)cell;
- (void)refreshOffers;

@end

@interface BBSOfferCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) id<BBSOfferCellDelegate> delegate;

- (void)updateOffer:(BBSOffer *)offer;

@end
