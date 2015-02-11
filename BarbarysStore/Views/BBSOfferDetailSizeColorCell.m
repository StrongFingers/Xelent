//
//  BBSOfferDetailSizeColorCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/11/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferDetailSizeColorCell.h"

#import "BBSOfferDetailSizeItemCell.h"

@interface BBSOfferDetailSizeColorCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *sizeCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *colorCollectionView;

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

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBSOfferDetailSizeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"offerSizeItemCell" forIndexPath:indexPath];
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

@end
