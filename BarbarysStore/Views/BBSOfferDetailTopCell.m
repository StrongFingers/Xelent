//
//  BBSOfferDetailTopCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/10/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferDetailTopCell.h"


#import <UIImageView+WebCache.h>

@interface BBSOfferDetailTopCell () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *yourSizeImageView;
@property (weak, nonatomic) IBOutlet UIButton *addToFavoritesButton;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *imagesPageControl;


@end

@implementation BBSOfferDetailTopCell

- (void)awakeFromNib {
    // Initialization code
    self.imagesScrollView.clipsToBounds = YES;
    [self.imagesScrollView setCanCancelContentTouches:NO];
    self.imagesScrollView.pagingEnabled = YES;

    self.imagesScrollView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setOffer:(BBSOffer *)offer {
    self.imagesPageControl.numberOfPages = [offer.pictures count];
    self.imagesPageControl.currentPage = 0;
    [self layoutScrollImages:offer.pictures];
    self.modelLabel.text = offer.model;
    self.priceLabel.text = offer.price;
}

- (void)layoutScrollImages:(NSArray *)images {
        NSUInteger i;
    for (i = 0; i < [images count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:images[i]];
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
@end
