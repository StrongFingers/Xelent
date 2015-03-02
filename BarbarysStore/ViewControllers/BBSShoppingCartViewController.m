//
//  BBSShoppingCartViewController.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/9/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSShoppingCartViewController.h"
#import "BBSShoppingCartCell.h"
#import "BBSCartOffer.h"
#import "BBSOfferDetailViewController.h"
#import "XLNDatabaseManager.h"

#import "UIImage+Alpha.h"

@interface BBSShoppingCartViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *offersTableView;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UILabel *summaryPriceLabel;
@property (nonatomic, strong) NSArray *shoppingItems;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *historyBarButton;

- (IBAction)orderOffers:(id)sender;
@end

@implementation BBSShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LOC(@"shoppingCartViewController.title");
    [self.orderButton setTitle:LOC(@"shoppingCartViewController.takeOrderButton.title") forState:UIControlStateNormal];
    self.historyBarButton.title = LOC(@"shoppingCartViewController.historyButton.title");
    [self.orderButton setBackgroundImage:[[UIImage imageWithColor:[UIColor priceColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 0, 0)] forState:UIControlStateHighlighted];
    [self.orderButton setBackgroundImage:[[UIImage imageWithColor:[UIColor mainDarkColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 0, 0)] forState:UIControlStateNormal];
    self.orderButton.layer.cornerRadius = 3;
    self.orderButton.clipsToBounds = YES;
    self.shoppingItems = [[NSMutableArray alloc] init];
    [self.offersTableView setTableFooterView:[UIView new]];
}

- (void)viewWillAppear:(BOOL)animated {
    XLNDatabaseManager *databaseManager = [[XLNDatabaseManager alloc] init];
    self.shoppingItems = [databaseManager getShoppingCart];
    NSInteger price = 0;
    for (BBSOffer *offer in self.shoppingItems) {
        price += [offer.price integerValue];
    }
    self.summaryPriceLabel.text = [NSString stringWithFormat:LOC(@"shoppingCargViewController.summaryPrice"), price];
    [self.offersTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)orderOffers:(id)sender {
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.shoppingItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBSShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBSShoppingCartCell"];
    if (!cell) {
        cell = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BBSShoppingCartCell"];
    }
    [cell setOffer:self.shoppingItems[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BBSOfferDetailViewController *offerDetailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OffersDetailViewController"];
    offerDetailVC.offerId = ((BBSOffer *)self.shoppingItems[indexPath.row]).offerId;
    offerDetailVC.fromShoppingCart = YES;
    [self.navigationController pushViewController:offerDetailVC animated:YES];
}

@end
