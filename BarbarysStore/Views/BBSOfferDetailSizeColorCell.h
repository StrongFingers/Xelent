//
//  BBSOfferDetailSizeColorCell.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/11/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSOfferDetailSizeColorCell : UITableViewCell

- (void)updateSizes:(NSArray *)sizes;
- (void)updateColors:(NSDictionary *)colors selectedColor:(NSString *)colorId;

@end
