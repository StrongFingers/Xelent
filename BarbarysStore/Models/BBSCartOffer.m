//
//  BBSCartOffer.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/20/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSCartOffer.h"

@implementation BBSCartOffer

- (id)initWithOffer:(BBSOffer *)offer {
    if (self = [super init]) {
        [self setup:offer];
        self.size = @"";
        self.choosedColor = @"";
        self.quantity = @"";
    }
    return self;
}

- (void)setup:(BBSOffer *)offer {
    self.url = offer.url;
    self.thumbnailUrl = offer.thumbnailUrl;
    self.offerId = offer.offerId;
    self.model = offer.model;
    self.categoryId = offer.categoryId;
    self.brand = offer.brand;
    self.currency = offer.currency;
    self.price = offer.price;
    self.brandAboutDescription = offer.brandAboutDescription;
    self.descriptionText = offer.descriptionText;
    self.color = offer.color;
    self.gender = offer.gender;
    self.material = offer.material;
    self.pictures = offer.pictures;
    self.colorsType = offer.colorsType;
    self.sizesType = offer.sizesType;
}

@end
