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
@property (weak, nonatomic) IBOutlet UILabel *offerModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerPriceLabel;

@end

@implementation BBSOfferCollectionViewCell

- (void)setOffer:(BBSOffer *)offer {
    if ([offer.pictures count] > 0) {
        NSURL *imageUrl = [[NSURL alloc] initWithString:[offer.pictures firstObject]];
        [self.offerImageView sd_setImageWithURL:imageUrl placeholderImage:nil];
    }
    self.offerVendorLabel.text = offer.vendor;
    self.offerModelLabel.text = offer.model;
    self.offerPriceLabel.text = offer.price;
}

@end
