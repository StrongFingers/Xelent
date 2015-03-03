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
#import "BBSOfferManager.h"

@interface BBSFavoritesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BBSOfferCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *favoritesCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *singleItemButton;
@property (weak, nonatomic) IBOutlet UIButton *multiplyItemButton;
@property (nonatomic, strong) NSArray *offers;
@property (nonatomic, assign) BOOL isMultiplyCell;

@end

@implementation BBSFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LOC(@"favoritesViewController.title");
    [self.favoritesCollectionView registerNib:[UINib nibWithNibName:@"BBSOfferCollectionCellType1" bundle:nil] forCellWithReuseIdentifier:@"offerCollectionCell"];
    [self.favoritesCollectionView registerNib:[UINib nibWithNibName:@"BBSOfferCollectionCellType2" bundle:nil] forCellWithReuseIdentifier:@"offerCellType2"];
    self.offers = [NSArray new];
    self.isMultiplyCell = YES;
    self.multiplyItemButton.selected = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateFavorites];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void)updateFavorites {
    BBSOfferManager *offerManager = [[BBSOfferManager alloc] init];
    self.offers = [offerManager getFavorites];
    [self.favoritesCollectionView reloadData];
}

#pragma mark - IBActions

- (IBAction)changePresentView:(id)sender {
    UIButton *selectedButton = (UIButton *)sender;
    if (([selectedButton isEqual:self.multiplyItemButton] && self.isMultiplyCell) || ([selectedButton isEqual:self.singleItemButton] && !self.isMultiplyCell)) {
        return;
    }
    self.isMultiplyCell = !self.isMultiplyCell;
    self.multiplyItemButton.selected = !self.multiplyItemButton.selected;
    self.singleItemButton.selected = !self.singleItemButton.selected;
    [self.favoritesCollectionView reloadData];
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
    [cell updateOffer:self.offers[indexPath.row] isMultiplyCell:self.isMultiplyCell];
    cell.delegate = self;
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
    //offerDetailVC.offerId = ((BBSOffer *)self.offers[indexPath.row]).offerId;
    offerDetailVC.fromFavorites = YES;
    [offerDetailVC updateOffer:self.offers[indexPath.row]];
    [self.navigationController pushViewController:offerDetailVC animated:YES];
}

- (IBAction)segmentedValueChanged:(id)sender {
    NSNumber *index = @(self.segmentedControl.selectedSegmentIndex);
    self.isMultiplyCell = [index boolValue];
    [self.favoritesCollectionView reloadData];
}

#pragma mark - BBSOfferCell defelate

- (void)refreshOffers {
    [self updateFavorites];
}

@end
