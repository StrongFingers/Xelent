//
//  Offer.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOffer.h"

@implementation BBSOffer

- (id)init {
    if (self = [super init]) {
        self.url = @"";
        self.thumbnailUrl = @"";
        self.offerId = @"";
        self.model = @"";
        self.categoryId = @"";
        self.brand = @"";
        self.currency = @"";
        self.price = @"";
//       self.descriptionText = (NSAttributedString*) @"";
        self.descriptionText =@"";
        self.color = @"";
        self.gender = @"";
        self.material = @"";
        self.brandAboutDescription = @"";
    }
    return self;
}

- (BOOL)isEqual:(BBSOffer *)anObject
{
    return [self.offerId isEqual:anObject.offerId];
}

- (NSUInteger)hash
{
    return self.offerId.hash;
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
        self.brand = [decoder decodeObjectForKey:@"vendor"];
        self.currency = [decoder decodeObjectForKey:@"currency"];
        self.price = [decoder decodeObjectForKey:@"price"];
//        self.descriptionText = [decoder decodeObjectForKey:@"descriptionText"];
        self.descriptionText = [decoder decodeObjectForKey:@"descriptionText"];
        self.color = [decoder decodeObjectForKey:@"color"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.material = [decoder decodeObjectForKey:@"material"];
        self.pictures = [decoder decodeObjectForKey:@"pictures"];
        self.colorsType = [decoder decodeObjectForKey:@"colorsType"];
        self.sizesType = [decoder decodeObjectForKey:@"sizesType"];
        self.brandAboutDescription = [decoder decodeObjectForKey:@"brandAboutDescription"];
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
    [encoder encodeObject:self.brand forKey:@"vendor"];
    [encoder encodeObject:self.currency forKey:@"currency"];
    [encoder encodeObject:self.price forKey:@"price"];
 //   [encoder encodeObject:self.descriptionText forKey:@"descriptionText"];
    [encoder encodeObject:self.descriptionText forKey:@"descriptionText"];
    [encoder encodeObject:self.color forKey:@"color"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.material forKey:@"material"];
    [encoder encodeObject:self.pictures forKey:@"pictures"];
    [encoder encodeObject:self.colorsType forKey:@"colorsType"];
    [encoder encodeObject:self.sizesType forKey:@"sizesType"];
    [encoder encodeObject:self.brandAboutDescription forKey:@"brandAboutDescription"];
}

@end
