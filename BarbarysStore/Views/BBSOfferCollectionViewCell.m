//
//  BBSOfferCollectionViewCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferCollectionViewCell.h"

#import "XLNDatabaseManager.h"
#import <Realm.h>
#import <UIImageView+WebCache.h>

@interface BBSOfferCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UILabel *offerVendorLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;
@property (nonatomic, strong) BBSOffer *offer;

- (IBAction)addToFavorite:(id)sender;

@end

@implementation BBSOfferCollectionViewCell

- (void)updateOffer:(BBSOffer *)offer {
    if ([offer isInvalidated]) {
        DLog(@"INVAL");
    }
    _offer = [offer copy];
    BBSOffer *off = offer;
    if (![off.thumbnailUrl isEqualToString:@""]) {
        NSURL *imageUrl = [[NSURL alloc] initWithString:offer.thumbnailUrl];
        [self.offerImageView sd_setImageWithURL:imageUrl placeholderImage:nil];
    }
    XLNDatabaseManager *manager = [[XLNDatabaseManager alloc] init];
    NSInteger count = [manager countOfRows:offer];
    if (count > 0) {
        [self.favoritesButton setImage:[UIImage imageNamed:@"favoritesButtonActive"] forState:UIControlStateHighlighted];
        self.favoritesButton.selected = YES;
    } else {
        [self.favoritesButton setImage:[UIImage new] forState:UIControlStateHighlighted];
        self.favoritesButton.selected = NO;
    }
    self.offerVendorLabel.text = offer.vendor;
    self.offerModelLabel.text = offer.model;
    self.offerPriceLabel.text = offer.price;
}

- (IBAction)addToFavorite:(id)sender {
    XLNDatabaseManager *manager = [[XLNDatabaseManager alloc] init];
    if (!self.favoritesButton.selected) {
        [manager addToFavorites:self.offer];
    } else {
        [manager removeFromFavorites:self.offer];
    }
    [self updateOffer:self.offer];
}

@end
