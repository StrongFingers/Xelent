//
//  BBSOfferDetailSizeItemCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/11/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferDetailSizeItemCell.h"

@interface BBSOfferDetailSizeItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation BBSOfferDetailSizeItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateTypeLabel:(NSString *)typeText {
    self.typeLabel.text = typeText;
}

@end
