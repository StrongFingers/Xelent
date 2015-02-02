//
//  BBSOfferCollectionViewCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferCollectionViewCell.h"

#import <UIImageView+WebCache.h>

@interface BBSOfferCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UILabel *offerVendorLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerPriceLabel;


@end

@implementation BBSOfferCollectionViewCell

- (void)setOffer:(BBSOffer *)offer {
    NSURL *imageUrl = [NSURL URLWithString:offer.url];
    [_offerImageView sd_setImageWithURL:imageUrl];
    self.offerVendorLabel.text = offer.vendor;
    self.offerDescriptionLabel.text = offer.descriptionText;
    self.offerPriceLabel.text = offer.price;
}

@end
