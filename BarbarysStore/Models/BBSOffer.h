//
//  Offer.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>

@interface PictureUrl : RLMObject <NSCopying>

@property (nonatomic, strong) NSString *url;

@end

RLM_ARRAY_TYPE(PictureUrl)

@interface BBSOffer : RLMObject <NSCopying, NSCoding>

@property (nonatomic, strong) NSString *offerId;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *vendor;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *material;
@property (nonatomic, strong) RLMArray<PictureUrl> *pictures;

@end
