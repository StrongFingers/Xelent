//
//  Offer.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOffer.h"

@implementation PictureUrl

@end

@implementation BBSOffer

- (id)init {
    if (self = [super init]) {
        self.url = @"";
        self.thumbnailUrl = @"";
        self.offerId = @"";
        self.model = @"";
        self.categoryId = @"";
        self.vendor = @"";
        self.currency = @"";
        self.price = @"";
        self.descriptionText = @"";
        self.color = @"";
        self.gender = @"";
        self.material = @"";
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    BBSOffer *newOffer = [[BBSOffer allocWithZone:zone] init];
    newOffer->_url = [_url copyWithZone:zone];
    newOffer->_thumbnailUrl = [_thumbnailUrl copyWithZone:zone];
    newOffer->_offerId = [_offerId copyWithZone:zone];
    newOffer->_model = [_model copyWithZone:zone];
    newOffer->_categoryId = [_categoryId copyWithZone:zone];
    newOffer->_vendor = [_vendor copyWithZone:zone];
    newOffer->_currency = [_currency copyWithZone:zone];
    newOffer->_price = [_price copyWithZone:zone];
    newOffer->_descriptionText = [_descriptionText copyWithZone:zone];
    newOffer->_color = [_color copyWithZone:zone];
    newOffer->_gender = [_gender copyWithZone:zone];
    newOffer->_material = [_material copyWithZone:zone];
    return newOffer;
}

@end
