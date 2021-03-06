//
//  BBSOfferDetailTopCell.m
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 8/26/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//
#import "BBSOfferDetailTopCell.h"

#import "BBSOfferManager.h"
#import <UIImageView+WebCache.h>

@interface BBSOfferDetailTopCell () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *yourSizeImageView;

@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *imagesPageControl;
@property (nonatomic, strong)        NSString *fromFavorite;
- (IBAction)nextImageButton:(id)sender;
- (IBAction)prevImageButton:(id)sender;


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

- (void)imageTapped:(UITapGestureRecognizer *)tapGesture {
    if ([self.delegate respondsToSelector:@selector(imageTapped:)]) {
        [self.delegate imageTapped:self.imagesPageControl.currentPage];
    }
}

- (IBAction)nextImageButton:(id)sender {
    if (self.imagesPageControl.currentPage + 1 < [self.offer.pictures[self.offer.color] count]) {
        self.imagesPageControl.currentPage = self.imagesPageControl.currentPage + 1;
        CGPoint offset = self.imagesScrollView.contentOffset;
        offset.x += 320;
        [self.imagesScrollView setContentOffset:offset animated:YES];
    }
    
}

- (IBAction)prevImageButton:(id)sender {
    if (self.imagesPageControl.currentPage > 0) {
        self.imagesPageControl.currentPage = self.imagesPageControl.currentPage - 1;
        CGPoint offset = self.imagesScrollView.contentOffset;
        offset.x -= 320;
        [self.imagesScrollView setContentOffset:offset animated:YES];
    }
}
@end
