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
@end
