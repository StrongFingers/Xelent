//
//  OfferManager.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferManager.h"
#import "XLNDatabaseManager.h"
#import "StripHTMLCategory.h"
#import <MWFeedParser/NSString+HTML.h>
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

+ (NSArray *)parseCategoryOffers:(NSArray *)offerData {
    NSMutableArray *offers = [[NSMutableArray alloc] init];
    for (NSDictionary *offerItem in offerData) {
        BBSOffer *offer = [[BBSOffer alloc] init];
        offer.brand = offerItem[@"brand"];
        offer.thumbnailUrl = offerItem[@"image"];
        offer.price = offerItem[@"price"];
        offer.offerId = offerItem[@"product_id"];
        offer.model = offerItem[@"product_name"];
        //changed
       // offer.sv_brandDescription = offerItem[@""];
       // offer.sv_productComposition = offerItem[@""];
        offer.color = offerItem[@"color_id"];
        [offers addObject:offer];
    }
    return offers;
}

+ (BBSOffer *)parseDetailOffer:(NSDictionary *)offerData {
    BBSOffer *newOffer = [[BBSOffer alloc] init];
    //newOffer.descriptionText = offerData[@"product_description"];
    newOffer.model = offerData[@"product_name"];
    newOffer.price = offerData[@"product_price"];
    NSArray *sv_brandDescription = offerData[@"brand"];

    NSString *brandDescriptions = @"";
    NSString *meta_value = @"meta_value";
    brandDescriptions = [sv_brandDescription[1] objectForKey:meta_value];
    newOffer.sv_brandDescription = [brandDescriptions stringByStrippingHTML:brandDescriptions];
    //newOffer.sv_brandDescription =[brandDescriptions stringByConvertingHTMLToPlainText];

    
    NSArray *items = offerData[@"items"];
    NSMutableDictionary *sizes = [NSMutableDictionary dictionary];
    NSMutableDictionary *colors = [NSMutableDictionary dictionary];
    for (NSDictionary *item in items) {
        NSString *sizeName = item[@"size_name"];
        if (!sizes[sizeName]) {
            NSMutableArray *sizeItems = [NSMutableArray array];
            [sizeItems addObject:item];
            [sizes setObject:sizeItems forKey:sizeName];
        } else {//probably here issue with wrong sizes
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

    NSString *tmpDescription = [offerData[@"product_description"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    tmpDescription = [tmpDescription stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    NSMutableAttributedString *attDescription = [[NSMutableAttributedString alloc] initWithString:tmpDescription];
    NSArray *properties = offerData[@"properties"];
    for (NSDictionary *property in properties) {
        if ([property[@"property_type"] isEqualToString:@"brand"]) {
            newOffer.brand = property[@"property_name"];
            NSString *brantString = [NSString stringWithFormat:@"\n%@: %@", property[@"property_type_name"], property[@"property_name"]];
            NSMutableAttributedString *attTmpString = [[NSMutableAttributedString alloc] initWithString:brantString attributes:@{NSFontAttributeName : [UIFont lightFont:15]}];
            [attTmpString addAttribute:NSFontAttributeName value:[UIFont mediumFont:15] range:NSMakeRange(0, [brantString rangeOfString:@":"].location)];
            [attDescription appendAttributedString:attTmpString];
        }
        if ([property[@"property_type"] isEqualToString:@"country_production"]) {
            NSString *brantString = [NSString stringWithFormat:@"\n%@: %@", property[@"property_type_name"], property[@"property_name"]];
            NSMutableAttributedString *attTmpString = [[NSMutableAttributedString alloc] initWithString:brantString attributes:@{NSFontAttributeName : [UIFont lightFont:15]}];
            [attTmpString addAttribute:NSFontAttributeName value:[UIFont mediumFont:15] range:NSMakeRange(0, [brantString rangeOfString:@":"].location)];
            [attDescription appendAttributedString:attTmpString];
        }
    }
    newOffer.descriptionText = attDescription;
    NSDictionary *images = offerData[@"images"];
    NSMutableDictionary *pictures = [NSMutableDictionary dictionary];
    for (NSString *key in images) {
        [pictures setObject:images[key] forKey:key];
    }
    newOffer.pictures = pictures;
    return newOffer;
}

- (void)updateOfferInFavorites:(BBSOffer *)offer state:(offerState)state {
    XLNDatabaseManager *manager = [[XLNDatabaseManager alloc] init];
    switch (state) {
        case offerAdd:
            [manager addToFavorites:offer];
            break;
        case offerDelete:
            [manager removeFromFavorites:offer];
            break;
        case offerUpdate:
            [manager updateFavorite:offer];
            break;
    }
}

- (NSInteger)countOfRows:(BBSOffer *)offer {
    XLNDatabaseManager *manager = [[XLNDatabaseManager alloc] init];
    return [manager countOfRows:offer];
}

- (NSArray *)getFavorites {
    XLNDatabaseManager *manager = [[XLNDatabaseManager alloc] init];
    return [manager getFavorites];
}

- (NSArray *)getShoppingCart {
    XLNDatabaseManager *manager = [[XLNDatabaseManager alloc] init];
    return [manager getShoppingCart];
}

- (void)addToShoppingCart:(BBSCartOffer *)offer {
    XLNDatabaseManager *manager = [[XLNDatabaseManager alloc] init];
    [manager addToShoppingCart:offer];
}

- (void)removeFromShoppingCart:(BBSCartOffer *)offer {
    XLNDatabaseManager *manager = [[XLNDatabaseManager alloc] init];
    [manager removeFromShoppingCart:offer];
}

- (void)addToHistory:(BBSHistoryItem *)historyItem {
    XLNDatabaseManager *manager = [[XLNDatabaseManager alloc] init];
    [manager addToHistory:historyItem];
}

- (NSArray *)loadFromHistory {
    XLNDatabaseManager *manager = [[XLNDatabaseManager alloc] init];
    return [manager loadFromHistory];
}

@end
