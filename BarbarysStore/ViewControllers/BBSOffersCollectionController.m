//
//  BBSOffersCollectionController.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOffersCollectionController.h"
#import "BBSOfferCollectionViewCell.h"
#import "XLNDatabaseManager.h"
#import "XLNParser.h"
#import "BBSOfferDetailViewController.h"

@interface BBSOffersCollectionController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *offersCollectionView;
@property (nonatomic, strong) NSArray *offers;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, assign) BOOL isMultiplyCell;
- (IBAction)segmentedValueChanged:(id)sender;
- (IBAction)showSearchController:(id)sender;

@end

@implementation BBSOffersCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserverForName:@"updateOffers" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary *userInfo = note.userInfo;
        self.offers = [[[XLNDatabaseManager alloc] init] getOffersByCategoryId:userInfo[@"categoryId"]];
        [self.offersCollectionView reloadData];
    }];
    //NSURL *url = [NSURL URLWithString:@"http://barbarys.com/aggregator/aggregatorall/yml.xml"];
    //[[XLNParser alloc] ininWithURL:url];
    [self.offersCollectionView registerNib:[UINib nibWithNibName:@"BBSOfferCollectionCellType2" bundle:nil] forCellWithReuseIdentifier:@"offerCellType2"];
    self.isMultiplyCell = NO;
    [self setNeedsStatusBarAppearanceUpdate];
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
    [cell setOffer:self.offers[indexPath.row]];
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
    [self.navigationController pushViewController:offerDetailVC animated:YES];
}

- (IBAction)segmentedValueChanged:(id)sender {
    NSNumber *index = @(self.segmentedControl.selectedSegmentIndex);
    self.isMultiplyCell = [index boolValue];
    [self.offersCollectionView reloadData];
}

- (IBAction)showSearchController:(id)sender {
    UIViewController *searchCtrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:searchCtrl animated:YES];
}

@end
