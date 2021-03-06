//
//  BBSOfferDetailTopCell.h
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 8/26/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSOffer.h"

@protocol offerDetailTopCellDelegate <NSObject>

- (void)imageTapped:(NSInteger)imageIndex;

@end

@interface BBSOfferDetailTopCell : UITableViewCell

@property (nonatomic, strong) BBSOffer *offer;
@property (nonatomic, strong) id<offerDetailTopCellDelegate> delegate;

- (void)updateElements;

@end
