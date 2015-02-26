//
//  BBSOfferDetailSizeColorCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/11/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferDetailSizeColorCell.h"
#import "BBSOfferDetailSizeItemCell.h"
#import "XLNDatabaseManager.h"
#import "UIImage+Alpha.h"

@interface BBSOfferDetailSizeColorCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *sizeCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *colorCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
@property (nonatomic, strong) NSArray *sizes;
@property (nonatomic, strong) NSArray *colors;

- (IBAction)addToShoppingCart:(id)sender;

@end

@implementation BBSOfferDetailSizeColorCell

- (void)awakeFromNib {
    // Initialization code
    self.sizeCollectionView.delegate = self;
    self.sizeCollectionView.dataSource = self;
    self.colorCollectionView.delegate = self;
    self.colorCollectionView.dataSource = self;
    [self.sizeCollectionView registerNib:[UINib nibWithNibName:@"BBSOfferDetailSizeItemCell" bundle:nil] forCellWithReuseIdentifier:@"offerSizeItemCell"];
    [self.colorCollectionView registerNib:[UINib nibWithNibName:@"BBSOfferDetailSizeItemCell" bundle:nil] forCellWithReuseIdentifier:@"offerSizeItemCell"];
    self.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    [self.addToCartButton setTitle:LOC(@"offerDetail.addToShoppingCartButton.title") forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundImage:[[UIImage imageWithColor:[UIColor priceColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 0, 0)] forState:UIControlStateHighlighted];
    [self.addToCartButton setBackgroundImage:[[UIImage imageWithColor:[UIColor mainDarkColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 0, 0)] forState:UIControlStateNormal];
    self.addToCartButton.layer.cornerRadius = 3;
    self.addToCartButton.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateSizes:(NSArray *)sizes {
    self.sizes = sizes;
    [self.sizeCollectionView reloadData];
}

- (void)updateColors:(NSArray *)colors {
    self.colors = colors;
    [self.colorCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.sizeCollectionView]) {
        return [self.sizes count];
    }
    return [self.colors count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBSOfferDetailSizeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"offerSizeItemCell" forIndexPath:indexPath];
    if ([collectionView isEqual:self.sizeCollectionView]) {
        [cell updateTypeLabel:self.sizes[indexPath.row]];
    } else {
        [cell updateTypeBackgroundColor:self.colors[indexPath.row]];
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat cellSpacing = ((UICollectionViewFlowLayout *) collectionViewLayout).minimumLineSpacing;
    CGFloat cellWidth = ((UICollectionViewFlowLayout *) collectionViewLayout).itemSize.width;
    NSInteger cellCount = [collectionView numberOfItemsInSection:section];
    CGFloat inset = (collectionView.bounds.size.width - (cellCount * (cellWidth + cellSpacing))) * 0.5;
    inset = MAX(inset, 0.0);
    return UIEdgeInsetsMake(0.0, inset, 0.0, 0.0);
}

- (IBAction)addToShoppingCart:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addToShoppingCart" object:nil];
}

@end
