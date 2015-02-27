//
//  BBSOfferDetailSizeItemCell.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/11/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSOfferDetailSizeItemCell : UICollectionViewCell

- (void)updateTypeLabel:(NSString *)typeText selected:(BOOL)isSelected;
- (void)updateTypeBackgroundColor:(NSString *)colorHex selected:(BOOL)isSelected;

@end
