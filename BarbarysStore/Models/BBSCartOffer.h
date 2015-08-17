//
//  BBSCartOffer.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/20/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOffer.h"

@interface BBSCartOffer : BBSOffer

@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *choosedColor;
@property (nonatomic, strong) NSString *quantity;

- (id)initWithOffer:(BBSOffer *)offer;

@end
