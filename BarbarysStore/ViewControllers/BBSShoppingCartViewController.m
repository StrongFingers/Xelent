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

#import <Realm.h>

@interface BBSShoppingCartViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *offersTableView;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UILabel *summaryPriceLabel;
@property (nonatomic, strong) NSMutableArray *shoppingItems;

- (IBAction)orderOffers:(id)sender;
@end

@implementation BBSShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.shoppingItems = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.shoppingItems removeAllObjects];
    RLMResults *result = [BBSCartOffer allObjects];
    for (BBSCartOffer *offer in result) {
        [self.shoppingItems addObject:offer];
    }
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
    
}

@end
