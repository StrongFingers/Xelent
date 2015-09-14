//
//  BBSOfferDetailSizeColorCell.h
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 8/26/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSOfferDetailSizeColorCell : UITableViewCell
@property (nonatomic, strong) NSArray *defaultSizes;


- (void)updateSizes:(NSArray *)sizes selectedSize:(NSString *)selectedSize;
- (void)updateColors:(NSDictionary *)colors selectedColor:(NSString *)colorId;

@end
