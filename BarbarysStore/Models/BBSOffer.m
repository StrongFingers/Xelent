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
    //newOffer->_pictures = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:_pictures]];
    return newOffer;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.url = [decoder decodeObjectForKey:@"url"];
        self.thumbnailUrl = [decoder decodeObjectForKey:@"thumbnailUrl"];
        self.offerId = [decoder decodeObjectForKey:@"offerId"];
        self.model = [decoder decodeObjectForKey:@"model"];
        self.categoryId = [decoder decodeObjectForKey:@"categoryId"];
        self.vendor = [decoder decodeObjectForKey:@"vendor"];
        self.currency = [decoder decodeObjectForKey:@"currency"];
        self.price = [decoder decodeObjectForKey:@"price"];
        self.descriptionText = [decoder decodeObjectForKey:@"descriptionText"];
        self.color = [decoder decodeObjectForKey:@"color"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.material = [decoder decodeObjectForKey:@"material"];
        self.pictures = [decoder decodeObjectForKey:@"pictures"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.thumbnailUrl forKey:@"thumbnailUrl"];
    [encoder encodeObject:self.offerId forKey:@"offerId"];
    [encoder encodeObject:self.model forKey:@"model"];
    [encoder encodeObject:self.categoryId forKey:@"categoryId"];
    [encoder encodeObject:self.vendor forKey:@"vendor"];
    [encoder encodeObject:self.currency forKey:@"currency"];
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeObject:self.descriptionText forKey:@"descriptionText"];
    [encoder encodeObject:self.color forKey:@"color"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.material forKey:@"material"];
    [encoder encodeObject:self.pictures forKey:@"pictures"];
}

@end
