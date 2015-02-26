//
//  OfferManager.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferManager.h"
#import "XLNDatabaseManager.h"

@interface BBSOfferManager ()

@property (nonatomic, strong) NSArray *offers;
@end

@implementation BBSOfferManager

- (id)init {
    if (self = [super init]) {
        self.offers = [[NSArray alloc] init];
    }
    return self;
}

- (id)initWithOffers:(NSArray *)offers {
    if (self = [super init]) {
        self.offers = offers;
    }
    return self;
}

- (void)saveToDB {
    XLNDatabaseManager *dbManager = [[XLNDatabaseManager alloc] init];
    [dbManager createDB];
    [dbManager addOffers:self.offers];
}

+ (NSArray *)parseCategoryOffers:(NSArray *)offerData {
    NSMutableSet *offers = [[NSMutableSet alloc] init];
    for (NSDictionary *offerItem in offerData) {
        BBSOffer *offer = [[BBSOffer alloc] init];
        offer.vendor = offerItem[@"brand"];
        offer.thumbnailUrl = offerItem[@"image"];
        offer.price = offerItem[@"price"];
        offer.offerId = offerItem[@"product_id"];
        offer.model = offerItem[@"product_name"];
        [offers addObject:offer];
    }
    return [offers allObjects];
}

+ (BBSOffer *)parseDetailOffer:(NSDictionary *)offerData {
    BBSOffer *newOffer = [[BBSOffer alloc] init];
    newOffer.descriptionText = offerData[@"product_description"];
    newOffer.model = offerData[@"product_name"];
    newOffer.price = offerData[@"product_price"];
    
    NSArray *items = offerData[@"items"];
    NSMutableDictionary *sizes = [NSMutableDictionary dictionary];
    NSMutableDictionary *colors = [NSMutableDictionary dictionary];
    for (NSDictionary *item in items) {
        NSString *sizeName = item[@"size_name"];
        if (!sizes[sizeName]) {
            NSMutableArray *sizeItems = [NSMutableArray array];
            [sizeItems addObject:item];
            [sizes setObject:sizeItems forKey:sizeName];
        } else {
            NSMutableArray *sizeItems = sizes[sizeName];
            [sizeItems addObject:item];
            [sizes setObject:sizeItems forKey:sizeName];
        }
        
        NSString *colorId = item[@"color_id"];
        if (!colors[colorId]) {
            NSMutableArray *colorItems = [NSMutableArray array];
            [colorItems addObject:item];
            [colors setObject:colorItems forKey:colorId];
        } else {
            NSMutableArray *colorItems = colors[colorId];
            [colorItems addObject:item];
            [colors setObject:colorItems forKey:colorId];
        }
    }
    newOffer.sizesType = sizes;
    newOffer.colorsType = colors;
    
    NSArray *properties = offerData[@"properties"];
    for (NSDictionary *property in properties) {
        if ([property[@"property_type"] isEqualToString:@"brand"]) {
            newOffer.vendor = property[@"property_name"];
        }
        /*if ([property[@"property_type"] isEqualToString:@"size"]) {
            [sizes addObject:property[@"property_name"]];
        }
        if ([property[@"property_type"] isEqualToString:@"color"]) {
            [colors addObject:property[@"property_name"]];
        }*/
    }
    return newOffer;
}

@end
