//
//  BBSFavoritesViewController.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/20/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSFavoritesViewController.h"
#import "BBSOffer.h"
#import "BBSOfferCollectionViewCell.h"
#import "BBSOfferDetailViewController.h"

#import <Realm.h>

@interface BBSFavoritesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *favoritesCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *offers;
@property (nonatomic, assign) BOOL isMultiplyCell;

- (IBAction)segmentedValueChanged:(id)sender;

@end

@implementation BBSFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LOC(@"favoritesViewController.title");
    [self.favoritesCollectionView registerNib:[UINib nibWithNibName:@"BBSOfferCollectionCellType1" bundle:nil] forCellWithReuseIdentifier:@"offerCollectionCell"];
    [self.favoritesCollectionView registerNib:[UINib nibWithNibName:@"BBSOfferCollectionCellType2" bundle:nil] forCellWithReuseIdentifier:@"offerCellType2"];
    self.offers = [NSMutableArray new];
    self.isMultiplyCell = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.offers removeAllObjects];
    RLMResults *results = [BBSOffer allObjects];
    for (BBSOffer *offer in results) {
        [self.offers addObject:offer];
    }

    [self.favoritesCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.offers count];
}

- (BBSOfferCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBSOfferCollectionViewCell *cell;
    if (self.isMultiplyCell) {
        cell = (BBSOfferCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"offerCollectionCell" forIndexPath:indexPath];
    } else {
        cell = (BBSOfferCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"offerCellType2" forIndexPath:indexPath];
    }
    [cell updateOffer:self.offers[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isMultiplyCell) {
        return CGSizeMake(300, 380);
    }
    return CGSizeMake(150, 260);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BBSOfferDetailViewController *offerDetailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OffersDetailViewController"];
    offerDetailVC.offer = self.offers[indexPath.row];
    offerDetailVC.fromFavorites = YES;
    [self.navigationController pushViewController:offerDetailVC animated:YES];
}

- (IBAction)segmentedValueChanged:(id)sender {
    NSNumber *index = @(self.segmentedControl.selectedSegmentIndex);
    self.isMultiplyCell = [index boolValue];
    [self.favoritesCollectionView reloadData];
}

@end
