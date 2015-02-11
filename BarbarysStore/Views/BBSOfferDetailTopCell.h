//
//  BBSOfferDetailTopCell.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/10/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSOffer.h"

@interface BBSOfferDetailTopCell : UITableViewCell

@property (nonatomic, strong, setter=setOffer:) BBSOffer *offer;

- (void)setOffer:(BBSOffer *)offer;

@end
