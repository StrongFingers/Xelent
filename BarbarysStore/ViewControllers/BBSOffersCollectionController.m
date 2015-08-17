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
#import "BBSAPIRequest.h"
#import "BBSOfferManager.h"

#import <MBProgressHUD.h>
#import "UIImage+Alpha.h"
#import <SWRevealViewController.h>
#import "NMRangeSlider.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

@interface BBSOffersCollectionController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BBSAPIRequestDelegate, SWRevealViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *offersCollectionView;
@property (nonatomic, strong) NSMutableArray *offers;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, assign) BOOL isMultiplyCell;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *findButton;
@property (weak, nonatomic) IBOutlet NMRangeSlider *priceSlider;
@property (weak, nonatomic) IBOutlet UILabel *lowerPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *singleItemButton;
@property (weak, nonatomic) IBOutlet UIButton *multiplyItemButton;
@property (nonatomic, strong) BBSAPIRequest *offerRequest;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString *selectedCategory;
@property (nonatomic, strong) NSString *selectedGender;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (IBAction)showSearchController:(id)sender;
- (IBAction)priceSliderValueChanged:(id)sender;

@end

@implementation BBSOffersCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.revealViewController.delegate = self;
    self.offerRequest = [[BBSAPIRequest alloc] initWithDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"updateOffers" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary *userInfo = note.userInfo;
        [self.offers removeAllObjects];
        self.currentPage = 1;
        if ([userInfo[@"gender"] isEqual:@(0)]) {
            self.selectedGender = @"women";
        } else if ([userInfo[@"gender"] isEqual:@(1)]) {
            self.selectedGender = @"men";
        } else {
            self.selectedGender = @"children";
        }
        self.selectedCategory = userInfo[@"categoryId"];
        [self.offerRequest getCategoryOffers:self.selectedCategory gender:self.selectedGender page:self.currentPage];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.revealViewController revealToggleAnimated:YES];
        self.menuButton.selected = NO;
    }];

    [self customizeControls];
    [self customizeSlider];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadNewOffers) forControlEvents:UIControlEventValueChanged];
    self.offersCollectionView.bottomRefreshControl = self.refreshControl;

}

- (void)viewWillAppear:(BOOL)animated {
    [self.offersCollectionView reloadData];
    if ([self.offers count] == 0) {
        [self showMenu:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Customize UI

- (void)customizeControls {
    self.navigationItem.title = LOC(@"offersViewController.title");
    [self.offersCollectionView registerNib:[UINib nibWithNibName:@"BBSOfferCollectionCellType1" bundle:nil] forCellWithReuseIdentifier:@"offerCollectionCell"];
    [self.offersCollectionView registerNib:[UINib nibWithNibName:@"BBSOfferCollectionCellType2" bundle:nil] forCellWithReuseIdentifier:@"offerCellType2"];
    self.isMultiplyCell = YES;
    self.multiplyItemButton.selected = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.frame = CGRectMake(0, 0, 30, 30);
    [self.menuButton setImage:[UIImage imageNamed:@"menuButtonUnactive"] forState:UIControlStateNormal];
    [self.menuButton setImage:[UIImage imageNamed:@"menuButtonActive"] forState:UIControlStateHighlighted];
    [self.menuButton setImage:[UIImage imageNamed:@"menuButtonActive"] forState:UIControlStateSelected];
    [self.menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.findButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.findButton.frame = CGRectMake(0, 0, 30, 30);
    [self.findButton setImage:[UIImage imageNamed:@"findButtonUnactive"] forState:UIControlStateNormal];
    [self.findButton setImage:[UIImage imageNamed:@"findButtonActive"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.findButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.lowerPriceLabel.textColor = [UIColor priceColor];
    self.upperPriceLabel.textColor = [UIColor priceColor];
}

- (void)customizeSlider {
    self.priceSlider.lowerHandleImageNormal = [[UIImage imageNamed:@"slider"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.priceSlider.upperHandleImageNormal = [[UIImage imageNamed:@"slider"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.priceSlider.lowerHandleImageHighlighted = [[UIImage imageNamed:@"sliderHighlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.priceSlider.upperHandleImageHighlighted = [[UIImage imageNamed:@"sliderHighlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

     self.priceSlider.trackBackgroundImage = [[UIImage imageWithColor:[UIColor mainDarkColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
   /* self.priceSlider.trackBackgroundImage = [[UIImage imageWithColor:[UIColor mainDarkColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];*/
    self.priceSlider.tintColor = [UIColor priceColor];
    self.priceSlider.minimumValue = 0;
    self.priceSlider.maximumValue = 100;
    
    self.priceSlider.lowerValue = 0;
    self.priceSlider.upperValue = 100;
    
    self.priceSlider.minimumRange = 10;
    
    self.lowerPriceLabel.text = [NSString stringWithFormat:LOC(@"offersViewController.priceSlider.lowerValue"), (int)self.priceSlider.lowerValue];
    self.upperPriceLabel.text = [NSString stringWithFormat:LOC(@"offersViewController.priceSlider.upperValue"), (int)self.priceSlider.upperValue];
}

- (void)updateSliderLabels {
    CGPoint lowerCenter;
    lowerCenter.x = (self.priceSlider.lowerCenter.x + self.priceSlider.frame.origin.x);
    lowerCenter.y = (self.priceSlider.center.y - 25.0f);
    self.lowerPriceLabel.center = lowerCenter;
    self.lowerPriceLabel.text = [NSString stringWithFormat:LOC(@"offersViewController.priceSlider.lowerValue"), (int)self.priceSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.priceSlider.upperCenter.x + self.priceSlider.frame.origin.x);
    upperCenter.y = (self.priceSlider.center.y - 25.0f);
    self.upperPriceLabel.center = upperCenter;
    self.upperPriceLabel.text = [NSString stringWithFormat:LOC(@"offersViewController.priceSlider.upperValue"), (int)self.priceSlider.upperValue];
}

#pragma mark - IBActions

- (IBAction)showMenu:(id)sender {
    self.menuButton.selected = !self.menuButton.selected;
    [self.revealViewController revealToggleAnimated:YES];
}

- (IBAction)priceSliderValueChanged:(id)sender {
    [self updateSliderLabels];
}

- (IBAction)changePresentView:(id)sender {
    UIButton *selectedButton = (UIButton *)sender;
    if (([selectedButton isEqual:self.multiplyItemButton] && self.isMultiplyCell) || ([selectedButton isEqual:self.singleItemButton] && !self.isMultiplyCell)) {
        return;
    }
    self.isMultiplyCell = !self.isMultiplyCell;
    self.multiplyItemButton.selected = !self.multiplyItemButton.selected;
    self.singleItemButton.selected = !self.singleItemButton.selected;
    [self.offersCollectionView reloadData];
}

#pragma mark - Methods

- (void)loadNewOffers {
    if (self.currentPage > 0) {
        [self.offerRequest getCategoryOffers:self.selectedCategory gender:self.selectedGender page:self.currentPage];
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
    }
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
    BBSOffer *offer = self.offers[indexPath.row];
    [cell updateOffer:offer isMultiplyCell:self.isMultiplyCell];
    //[self.offersCollectionView reloadData]; //*
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isMultiplyCell) {
        return CGSizeMake(300, 380);
    }
    return CGSizeMake(150, 243);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BBSOfferDetailViewController *offerDetailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OffersDetailViewController"];

    offerDetailVC.brandName = ((BBSOffer *)self.offers[indexPath.row]).brand;
    offerDetailVC.offerId = ((BBSOffer *)self.offers[indexPath.row]).offerId;
    offerDetailVC.selectedColor = ((BBSOffer *)self.offers[indexPath.row]).color;
    UIBarButtonItem *emptyNavigationBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:emptyNavigationBackButton];
    
    [self.navigationController pushViewController:offerDetailVC animated:YES];
}



- (IBAction)showSearchController:(id)sender {
    UIViewController *searchCtrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:searchCtrl animated:YES];
}

#pragma mark - SWRevealViewController delegate

- (BOOL)revealControllerTapGestureShouldBegin:(SWRevealViewController *)revealController {
    self.menuButton.selected = !self.menuButton.selected;
    return YES;
}

#pragma mark - BBSAPIRequest delegate

- (void)requestFinished:(id)responseObject sender:(id)sender {
    DLog(@"response_ %@", responseObject);
    [self.refreshControl endRefreshing];
    NSInteger allPages = [responseObject[0][@"pages_all"] integerValue];
    if (self.currentPage < allPages) {
        self.currentPage++;
    } else {
        self.currentPage = -1;
    }
    if (!self.offers) {
        self.offers = [NSMutableArray array];
    }
    [self.offers addObjectsFromArray:[BBSOfferManager parseCategoryOffers:responseObject[0][@"products"]]];
    
    [self.offersCollectionView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)requestFinishedWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
