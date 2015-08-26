//
//  BBSOfferDetailAbsentSizeCell.m
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 8/26/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferDetailAbsentSizeCell.h"
#import "BBSOfferDetailSizeItemCell.h"
#import "XLNDatabaseManager.h"
#import "UIImage+Alpha.h"
@interface BBSOfferDetailAbsentSizeCell () <UICollectionViewDelegate, UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UICollectionView *colorCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
//@property (nonatomic, strong) NSArray *sizes;
@property (nonatomic, strong) NSDictionary *colors;
@property (nonatomic, strong) NSString *selectedColor;
//@property (nonatomic, strong) NSString *selectedSize;

- (IBAction)addToShoppingCart:(id)sender;

@end
@implementation BBSOfferDetailAbsentSizeCell


- (void)awakeFromNib {
    // Initialization code
    self.colorCollectionView.delegate = self;
    self.colorCollectionView.dataSource = self;
    [self.colorCollectionView registerNib:[UINib nibWithNibName:@"BBSOfferDetailColorItemCell" bundle:nil] forCellWithReuseIdentifier:@"offerColorItemCell"];
    
    self.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    
    [self.addToCartButton setTitle:LOC(@"offerDetail.addToShoppingCartButton.title") forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundImage:[[UIImage imageWithColor:[UIColor mainDarkColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 0, 0)] forState:UIControlStateHighlighted];
    [self.addToCartButton setBackgroundImage:[[UIImage imageWithColor:[UIColor mainDarkColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 0, 0)] forState:UIControlStateSelected];
    [self.addToCartButton setBackgroundImage:[[UIImage imageWithColor:[UIColor priceColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 0, 0)] forState:UIControlStateNormal];
    self.addToCartButton.layer.cornerRadius = 3;
    self.addToCartButton.clipsToBounds = YES;
    
}

- (void)buttonSetDeselected
{
    [self.addToCartButton setSelected:NO];
    
}
- (void)buttonSetSelected:(UIButton *)button
{
    [self.addToCartButton setSelected:YES];
    [button setSelected:YES];
    [self performSelector:@selector(buttonSetDeselected) withObject:nil afterDelay:0.05];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)updateColors:(NSDictionary *)colors selectedColor:(NSString *)colorId {
    self.colors = colors;
    self.selectedColor = self.colors[colorId];
    [self.colorCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.colors count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

        BBSOfferDetailSizeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"offerColorItemCell" forIndexPath:indexPath];
        NSString *currentColorHex = self.colors[[self.colors allKeys][indexPath.row]];
        if ([currentColorHex isEqual:[NSNull null]]) {
            currentColorHex = @"000000";
            }
        NSAssert(![currentColorHex isEqual:[NSNull null]], @"Color hex is Null");
        
        [cell updateTypeBackgroundColor:currentColorHex selected:[currentColorHex isEqualToString:self.selectedColor]];
        
        return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat cellSpacing = ((UICollectionViewFlowLayout *) collectionViewLayout).minimumLineSpacing;
    CGFloat cellWidth = ((UICollectionViewFlowLayout *) collectionViewLayout).itemSize.width;
    NSInteger cellCount = [collectionView numberOfItemsInSection:section];
    CGFloat inset = (collectionView.bounds.size.width - (cellCount * (cellWidth + cellSpacing))) * 0.5;
    inset = MAX(inset, 0.0);
    return UIEdgeInsetsMake(0.0, inset, 0.0, 0.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        NSString *colorKey = [self.colors allKeys][indexPath.row];
        NSString *currentColorHex = self.colors[colorKey];
        if ([self.selectedColor isEqualToString:currentColorHex]) {
            return;
        }
        self.selectedColor = currentColorHex;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSizeColorSection" object:nil userInfo:@{@"selectedColor" : colorKey}];
}

- (IBAction)addToShoppingCart:(id)sender {
    [self buttonSetSelected:self.addToCartButton];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addToShoppingCart" object:nil userInfo:@{@"color" : [self.colors allKeysForObject:self.selectedColor][0], @"size" : LOC(@"offerDetail.sizeAbsent")}];
}

@end