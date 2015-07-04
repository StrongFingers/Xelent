//
//  Offer.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSOffer : NSObject <NSCopying, NSCoding>

@property (nonatomic, strong) NSString *offerId;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *brand;
//changed
@property (nonatomic, strong) NSAttributedString *sv_brandDescription;
@property (nonatomic, strong) NSString *sv_productComposition;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSAttributedString *descriptionText;
@property (nonatomic, strong) NSString *descriptionText_nonAtributed;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *material;
@property (nonatomic, strong) NSDictionary *pictures;
@property (nonatomic, strong) NSDictionary *sizesType;
@property (nonatomic, strong) NSDictionary *colorsType;

@end
