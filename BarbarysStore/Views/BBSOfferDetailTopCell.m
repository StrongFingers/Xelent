//
//  BBSOfferDetailTopCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/10/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferDetailTopCell.h"

#import "BBSOfferManager.h"
#import <UIImageView+WebCache.h>

@interface BBSOfferDetailTopCell () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *yourSizeImageView;
@property (weak, nonatomic) IBOutlet UIButton *addToFavoritesButton;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *imagesPageControl;
@property (nonatomic, strong)        NSString *fromFavorite;

- (IBAction)addToFavorites:(id)sender;

@end

@implementation BBSOfferDetailTopCell

- (void)awakeFromNib {
    // Initialization code
    self.imagesScrollView.clipsToBounds = YES;
    [self.imagesScrollView setCanCancelContentTouches:NO];
    self.imagesScrollView.pagingEnabled = YES;
    self.imagesScrollView.delegate = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.imagesScrollView addGestureRecognizer:tapGesture];
    self.priceLabel.font = [UIFont mediumFont:15];
    self.modelLabel.font = [UIFont lightFont:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)updateElements {
    if (!self.offer) {
        return;
    }
    self.imagesPageControl.numberOfPages = [self.offer.pictures[self.offer.color] count];
    self.imagesPageControl.currentPage = 0;
    if (!self.offer.pictures) {
        [self layoutScrollImages:@[self.offer.thumbnailUrl]];
    } else {
        [self layoutScrollImages:self.offer.pictures[self.offer.color]];
    }
    self.modelLabel.text = self.offer.model;
    self.priceLabel.text = [NSString stringWithFormat:LOC(@"offersViewController.price.title"), self.offer.price];
    BBSOfferManager *dbManager = [[BBSOfferManager alloc] init];
    NSInteger count = [dbManager countOfRows:self.offer];
    if ((count > 0) || (self.fromFavorite = @"1")) {
        self.addToFavoritesButton.selected = YES;
        self.fromFavorite = @"0";
    }
}

- (void)layoutScrollImages:(NSArray *)images {
    NSUInteger i;
    for (i = 0; i < [images count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSURL *imageUrl = [NSURL URLWithString:images[i]];
        [imageView sd_setImageWithURL:imageUrl];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        CGRect rect = imageView.frame;
        rect.origin.x = 320 * i;
        rect.origin.y = 0;
        rect.size.height = 380;
        rect.size.width = 320;
        imageView.frame = rect;
        [self.imagesScrollView addSubview:imageView];
    }
    CGSize size = CGSizeMake(([images count] * 320), [self.imagesScrollView bounds].size.height);
    [self.imagesScrollView setContentSize:size];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        // Page has changed, do your thing!
        self.imagesPageControl.currentPage = page;
        // Finally, update previous page
        previousPage = page;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

#pragma mark - IBActions

- (IBAction)addToFavorites:(id)sender {
    self.addToFavoritesButton.selected = !self.addToFavoritesButton.selected;
    BBSOfferManager *dbManager = [[BBSOfferManager alloc] init];
    if (self.addToFavoritesButton.selected) {
        self.fromFavorite = @"1";
        [dbManager updateOfferInFavorites:self.offer state:offerAdd];
    } else {
        [dbManager updateOfferInFavorites:self.offer state:offerDelete];
    }
}

- (void)imageTapped:(UITapGestureRecognizer *)tapGesture {
    if ([self.delegate respondsToSelector:@selector(imageTapped:)]) {
        [self.delegate imageTapped:self.imagesPageControl.currentPage];
    }
}

@end
