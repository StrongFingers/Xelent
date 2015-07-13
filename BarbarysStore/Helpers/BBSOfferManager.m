//
//  OfferManager.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferManager.h"
#import "XLNDatabaseManager.h"
#import "BBSAPIRequest.h"
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
    //    DLog(@"\n%@",offerItem);
        offer.brand = offerItem[@"brand"];
        offer.thumbnailUrl = offerItem[@"image"];
        offer.price = offerItem[@"price"];
        offer.offerId = offerItem[@"product_id"];
        offer.model = offerItem[@"product_name"];
        offer.color = offerItem[@"color_id"];
        
       // NSDictionary *categoryOfferData =
        [offers addObject:offer];
    }
    return offers;
}

+ (BBSOffer *)parseDetailOffer:(NSDictionary *)offerData {
    BBSOffer *newOffer = [[BBSOffer alloc] init];
    newOffer.model = offerData[@"product_name"];
    newOffer.price = offerData[@"product_price"];
    
    NSString *brandDescriptions = @"";
    NSString *meta_value = @"meta_value";
    NSArray *brandOfferData = offerData[@"brand"];
    if ( brandOfferData != NULL){
        for (NSDictionary *brand in brandOfferData) {
            if ([brand[@"meta_key"]  isEqual: @"brand_about_description"]) {
                brandDescriptions =[brand objectForKey:meta_value];
            }
        }
    } else {brandDescriptions = LOC(@"BBSOfferManager.brandAboutDescriptionNone");};
    
    newOffer.brandAboutDescription = [[[[brandDescriptions stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    
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
        } //overwrite when find size that already in dictionary.WHY?
        
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
    
    NSString *concreteOfferDescription = @"";
    if (![offerData[@"product_description"] isEqualToString:@""]) {concreteOfferDescription = [[[concreteOfferDescription stringByAppendingString:offerData[@"product_description"]] stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
        }
    
   // NSMutableAttributedString *atributedDescription = [[NSMutableAttributedString alloc] initWithString:concreteOfferDescription];
    NSArray *properties = offerData[@"properties"];
    
    
    if (properties)
    {for (NSDictionary *property in properties)
         {
            if ([property[@"property_type"] isEqualToString:@"brand"])
            {
                    newOffer.brand = property[@"property_name"];
                    NSString *brandString = [NSString stringWithFormat:@"\n%@: %@", property[@"property_type_name"], property[@"property_name"]];
                    concreteOfferDescription = [concreteOfferDescription stringByAppendingString:brandString];
            }
            if ([property[@"property_type"] isEqualToString:@"country_production"]) {
                NSString *temporaryString = [NSString stringWithFormat:@"\n%@: %@", property[@"property_type_name"], property[@"property_name"]];
                concreteOfferDescription = [concreteOfferDescription stringByAppendingString:temporaryString];
            }
            if ([property[@"property_type"] isEqualToString:@"material"]) {
                NSString *temporaryString = [NSString stringWithFormat:@"\n%@: %@", property[@"property_type_name"], property[@"property_name"]];
                concreteOfferDescription = [concreteOfferDescription stringByAppendingString:temporaryString];
            }
             if ([property[@"property_type"] isEqualToString:@"style"]) {
                 NSString *temporaryString = [NSString stringWithFormat:@"\n%@: %@", property[@"property_type_name"], property[@"property_name"]];
                 concreteOfferDescription = [concreteOfferDescription stringByAppendingString:temporaryString];

             }
             if ([property[@"property_type"] isEqualToString:@"fashion"]) {
                 NSString *temporaryString = [NSString stringWithFormat:@"\n%@: %@", property[@"property_type_name"], property[@"property_name"]];
                 concreteOfferDescription = [concreteOfferDescription stringByAppendingString:temporaryString];

             }
             if ([property[@"property_type"] isEqualToString:@"texture"]) {
                 NSString *temporaryString = [NSString stringWithFormat:@"\n%@: %@", property[@"property_type_name"], property[@"property_name"]];
                 concreteOfferDescription = [concreteOfferDescription stringByAppendingString:temporaryString];

             }
             if ([property[@"property_type"] isEqualToString:@"season"]) {
                 NSString *temporaryString = [NSString stringWithFormat:@"\n%@: %@", property[@"property_type_name"], property[@"property_name"]];
                 concreteOfferDescription = [concreteOfferDescription stringByAppendingString:temporaryString];

             }
             if ([property[@"property_type"] isEqualToString:@"lens_colour"]) {
                 NSString *temporaryString = [NSString stringWithFormat:@"\n%@: %@", property[@"property_type_name"], property[@"property_name"]];
                 concreteOfferDescription = [concreteOfferDescription stringByAppendingString:temporaryString];

             }
             
        }
    }
    newOffer.descriptionText =concreteOfferDescription;
    
    
    
    


    
       
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
            offer.FromFavorites = @"1";
            [manager getOfferToFavoriteById:offer];
           // [manager updateFavorite:offer];
            
            break;
        case offerDelete:
            offer.FromFavorites = @"0";
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
