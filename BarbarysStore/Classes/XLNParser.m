//
//  XLNParser.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "XLNParser.h"
#import "BBSOffer.h"
#import "BBSCategory.h"
#import "XLNDatabaseManager.h"

#import <TBXML.h>
#import <TBXML+HTTP.h>

@interface XLNParser ()

@property (nonatomic, strong) TBXML *parser;

@end

@implementation XLNParser

- (void)ininWithURL:(NSURL *)url {
    self.parser = [TBXML tbxmlWithURL:url success:^(TBXML *tbxmlDocument) {
        if (tbxmlDocument.rootXMLElement) {
            [self parseRootElement:tbxmlDocument.rootXMLElement];
        }
    } failure:^(TBXML *tbxmlDocument, NSError *error) {
        DLog(@"%@ %@", [error localizedDescription], [error userInfo]);
    }];
}

- (void)parseRootElement:(TBXMLElement *)rootElement {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"parsingStarted" object:nil];
    NSError *error;
    TBXMLElement *childElement = [TBXML childElementNamed:@"shop" parentElement:rootElement error:&error];
    TBXMLElement *categoriesElement = [TBXML childElementNamed:@"categories" parentElement:childElement];
    TBXMLElement *offersElement = [TBXML childElementNamed:@"offers" parentElement:childElement error:&error];
    NSArray *categories = [self getCategories:categoriesElement];
    NSArray *offers = [self getOffers:offersElement];
    
    XLNDatabaseManager *dbManager = [[XLNDatabaseManager alloc] init];
    [dbManager createDB];
    //[dbManager addCategories:categories];
    //[dbManager addOffers:offers];
}

- (NSArray *)getOffers:(TBXMLElement *)offersElement {
    NSMutableArray *offers = [[NSMutableArray alloc] init];
    NSError *error;
    TBXMLElement *offerElement = [TBXML childElementNamed:@"offer" parentElement:offersElement error:&error];
    do {
        BBSOffer *offer = [[BBSOffer alloc] init];
        NSString *offerId = [TBXML valueOfAttributeNamed:@"id" forElement:offerElement];
        offer.offerId = offerId;
        TBXMLElement *urlElement = [TBXML childElementNamed:@"url" parentElement:offerElement];
        offer.url = [TBXML textForElement:urlElement];
        TBXMLElement *priceElement = [TBXML childElementNamed:@"price" parentElement:offerElement];
        offer.price = [TBXML textForElement:priceElement];
        TBXMLElement *currencyElement = [TBXML childElementNamed:@"currencyId" parentElement:offerElement];
        offer.currency = [TBXML textForElement:currencyElement];
        TBXMLElement *categoryElement = [TBXML childElementNamed:@"categoryId" parentElement:offerElement];
        offer.categoryId = [TBXML textForElement:categoryElement];
        TBXMLElement *vendorElement = [TBXML childElementNamed:@"vendor" parentElement:offerElement];
        offer.brand = [TBXML textForElement:vendorElement];
        TBXMLElement *modelElement = [TBXML childElementNamed:@"model" parentElement:offerElement];
        offer.model = [TBXML textForElement:modelElement];
        TBXMLElement *descriptionElement = [TBXML childElementNamed:@"description" parentElement:offerElement];
        if (descriptionElement) {
           // offer.descriptionText = [TBXML textForElement:descriptionElement];
            offer.sv_descriptionText = (NSAttributedString *)[TBXML textForElement:descriptionElement];
        }
        
        TBXMLElement *pictureElement = [TBXML childElementNamed:@"picture" parentElement:offerElement];
        if (pictureElement) {
            NSString *pictureTagName = [NSString stringWithCString:pictureElement->name encoding:NSUTF8StringEncoding];
            NSMutableArray *pictures = [NSMutableArray array];
            do {
                pictureTagName = [NSString stringWithCString:pictureElement->nextSibling->name encoding:NSUTF8StringEncoding];
                NSString *url = [TBXML textForElement:pictureElement];
                [pictures addObject:url];
            } while ((pictureElement = pictureElement->nextSibling) && [pictureTagName isEqualToString:@"picture"]);
            offer.pictures = pictures;
            offer.thumbnailUrl = [pictures firstObject];
        }

        TBXMLElement *paramElement = [TBXML childElementNamed:@"param" parentElement:offerElement];
        do {
            NSString *noteText = [TBXML textForElement:paramElement];
            NSString *attributeText = [TBXML valueOfAttributeNamed:@"name" forElement:paramElement];
            if ([attributeText isEqualToString:@"Цвет"]) {
                offer.color = noteText;
            } else if ([attributeText isEqualToString:@"Пол"]) {
                offer.gender = noteText;
            } else if ([attributeText isEqualToString:@"Материал"]) {
                offer.material = noteText;
            }
        } while ((paramElement = paramElement->nextSibling) != nil);
        [offers addObject:offer];
    } while ((offerElement = offerElement->nextSibling) != nil);
    DLog(@"done offers");
    return offers;
}

- (NSArray *)getCategories:(TBXMLElement *)categoriesElement {
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    TBXMLElement *categoryElement = [TBXML childElementNamed:@"category" parentElement:categoriesElement];
    do {
        BBSCategory *category = [[BBSCategory alloc] init];
        NSString *categoryId = [TBXML valueOfAttributeNamed:@"id" forElement:categoryElement];
        NSString *parentId = [TBXML valueOfAttributeNamed:@"parentId" forElement:categoryElement];
        NSString *categoryName = [TBXML textForElement:categoryElement];
        category.categoryId = categoryId;
        category.parentId = parentId;
        category.name = categoryName;
        [categories addObject:category];
    } while ((categoryElement = categoryElement->nextSibling));
    return categories;
}
@end
