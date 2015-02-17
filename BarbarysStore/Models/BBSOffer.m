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

@end
