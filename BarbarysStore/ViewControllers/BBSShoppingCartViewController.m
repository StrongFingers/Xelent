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
#import "BBSOfferManager.h"
#import "BBSHistoryViewController.h"

#import "UIImage+Alpha.h"

@interface BBSShoppingCartViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *offersTableView;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UILabel *summaryPriceLabel;
@property (nonatomic, strong) NSArray *shoppingItems;
@property (nonatomic, strong) BBSOfferManager *offerManager;

- (IBAction)orderOffers:(id)sender;
@end

@implementation BBSShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizeUI];
    self.shoppingItems = [[NSMutableArray alloc] init];
    [self.offersTableView setTableFooterView:[UIView new]];
    self.offerManager = [[BBSOfferManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateCartData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Customisation

- (void)customizeUI {
    self.navigationItem.title = LOC(@"shoppingCartViewController.title");
    [self.orderButton setTitle:LOC(@"shoppingCartViewController.takeOrderButton.title") forState:UIControlStateNormal];
    UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    historyButton.frame = CGRectMake(0, 0, 68, 25);
    [historyButton setTitle:LOC(@"shoppingCartViewController.historyButton.title") forState:UIControlStateNormal];
    [historyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [historyButton setTitleColor:[UIColor priceColor] forState:UIControlStateHighlighted];
    historyButton.titleLabel.font = [UIFont mediumFont:14];
    [historyButton setBackgroundImage:[UIImage imageNamed:@"historyButton"] forState:UIControlStateNormal];
    [historyButton setBackgroundImage:[UIImage imageNamed:@"historyButtonActive"] forState:UIControlStateHighlighted];
    [historyButton addTarget:self action:@selector(showHistoryView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *historyBarButton = [[UIBarButtonItem alloc] initWithCustomView:historyButton];
    self.navigationItem.rightBarButtonItem = historyBarButton;
    
    [self.orderButton setBackgroundImage:[[UIImage imageWithColor:[UIColor priceColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 0, 0)] forState:UIControlStateHighlighted];
    [self.orderButton setBackgroundImage:[[UIImage imageWithColor:[UIColor mainDarkColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 0, 0)] forState:UIControlStateNormal];
    self.orderButton.layer.cornerRadius = 3;
    self.orderButton.clipsToBounds = YES;
    self.offersTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
}

#pragma mark - Methods

- (void)updateCartData {
    self.shoppingItems = [self.offerManager getShoppingCart];
    NSInteger price = 0;
    for (BBSOffer *offer in self.shoppingItems) {
        price += [offer.price integerValue];
    }
    self.summaryPriceLabel.text = [NSString stringWithFormat:LOC(@"shoppingCargViewController.summaryPrice"), price];
    [self.offersTableView reloadData];
}

#pragma mark - IBActions

- (IBAction)orderOffers:(id)sender {
    BBSHistoryItem *historyItem = [[BBSHistoryItem alloc] init];
    historyItem.createDate = @"05.03.2014";
    historyItem.summaryPrice = self.summaryPriceLabel.text;
    historyItem.saleValue = @"3%";
    historyItem.offers = self.shoppingItems;
    [self.offerManager addToHistory:historyItem];
}

- (IBAction)showHistoryView:(id)sender {
    [self performSegueWithIdentifier:@"toHistoryView" sender:self];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.offerManager removeFromShoppingCart:self.shoppingItems[indexPath.row]];
        [self updateCartData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LOC(@"shoppingCartViewController.deleteButton.title");
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BBSOfferDetailViewController *offerDetailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OffersDetailViewController"];
    offerDetailVC.offerId = ((BBSOffer *)self.shoppingItems[indexPath.row]).offerId;
    offerDetailVC.fromShoppingCart = YES;
    [self.navigationController pushViewController:offerDetailVC animated:YES];
}

@end
