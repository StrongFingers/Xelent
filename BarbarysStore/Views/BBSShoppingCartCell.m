//
//  BBSShoppingCartCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/20/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSShoppingCartCell.h"

#import "UIImageView+WebCache.h"

@interface BBSShoppingCartCell ()

@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UILabel *offerBrandLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation BBSShoppingCartCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOffer:(BBSCartOffer *)offer {
    NSURL *imageUrl = [NSURL URLWithString:offer.thumbnailUrl];
    [self.offerImageView sd_setImageWithURL:imageUrl];
    self.offerBrandLabel.text = offer.vendor;
    self.offerTypeLabel.text = offer.model;
    self.sizeLabel.text = offer.size;
    self.colorLabel.text = offer.choosedColor;
    self.quantityLabel.text = offer.quantity;
    self.priceLabel.text = offer.price;
}

@end
