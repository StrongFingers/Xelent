//
//  BBSOfferCollectionViewCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferCollectionViewCell.h"
#import <MBProgressHUD.h>
#import "BBSOfferManager.h"
#import <UIImageView+WebCache.h>
#import "XLNDatabaseManager.h"

@interface BBSOfferCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UILabel *offerVendorLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;
@property (nonatomic, strong) BBSOffer *offer;
@property (nonatomic, strong) BBSOfferManager *manager;
@property (nonatomic, strong) NSString *fromFavorites;
- (IBAction)addToFavorite:(id)sender;

@end

@implementation BBSOfferCollectionViewCell

- (void)awakeFromNib {
    self.manager = [[BBSOfferManager alloc] init];
    self.offerVendorLabel.font = [UIFont mediumFont:14];
    self.offerModelLabel.font = [UIFont lightFont:15];
    self.offerPriceLabel.font = [UIFont mediumFont:14];
    self.offerVendorLabel.textColor = [UIColor mainDarkColor];
    self.offerPriceLabel.textColor = [UIColor priceColor];
}

- (void)updateOffer:(BBSOffer *)offer isMultiplyCell:(BOOL)isMultiplyCell {
    _offer = offer;
    if (offer.thumbnailUrl && ![offer.thumbnailUrl isEqualToString:@""]) {
        NSURL *imageUrl = [[NSURL alloc] initWithString:offer.thumbnailUrl];
        NSString *placeholderImage = isMultiplyCell ? @"placeholderForDownloadingImage" : @"placeholderForDownloadingImageBig";
        [self.offerImageView sd_setImageWithURL:imageUrl placeholderImage:[[UIImage imageNamed:placeholderImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    NSInteger count = [self.manager countOfRows:offer];
    if ((count > 0) || [self.fromFavorites isEqualToString:@"1"])  {
        [self.favoritesButton setImage:[UIImage imageNamed:@"favoritesButtonActive"] forState:UIControlStateHighlighted];
         self.favoritesButton.selected = YES;
         self.fromFavorites = @"0";
        } else {
          [self.favoritesButton setImage:[UIImage imageNamed:@"favoritesButton"] forState:UIControlStateHighlighted];
           self.favoritesButton.selected = NO;

    }
    self.offerVendorLabel.text = offer.brand;
    self.offerModelLabel.text = offer.model;
    self.offerPriceLabel.text = [NSString stringWithFormat:LOC(@"offersViewController.price.title"), offer.price];
}

- (IBAction)addToFavorite:(id)sender {
    
    self.fromFavorites = @"1";
    [self.manager updateOfferInFavorites:self.offer state:!self.favoritesButton.selected ? offerAdd : offerDelete];
    [self updateOffer:self.offer isMultiplyCell:YES];
    [self.delegate refreshOffers];
    /*if ([self.delegate respondsToSelector:@selector(refreshOffers)]) {
        [self.delegate refreshOffers];
    }*/
}

@end
