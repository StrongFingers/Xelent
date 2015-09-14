//
//  BBSHistoryViewController.m
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 8/26/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSHistoryViewController.h"
#import "BBSHistoryCell.h"
#import "BBSHistoryItem.h"
#import "BBSOfferManager.h"
#import "XLNCommonMethods.h"

@interface BBSHistoryViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (weak, nonatomic) IBOutlet UILabel *summaryPriceLabel;
@property (nonatomic, strong) NSArray *historyItems;
@end

@implementation BBSHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    BBSOfferManager *manager = [[BBSOfferManager alloc] init];
    self.historyItems = [manager loadFromHistory];
    [self calculateTotalAmountSpendedMoneyOfArray:self.historyItems];
    [self.historyTableView setTableFooterView:[UIView new]];
    self.historyTableView.estimatedRowHeight = 12;
    self.historyTableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.historyTableView reloadData];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.historyItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBSHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    if (!cell) {
        cell = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BBSHistoryCell"];
    }
    [cell updateCellInfo:self.historyItems[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[NSBundle mainBundle] loadNibNamed:@"BBSHistorySectionHeader" owner:self options:nil][0];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 21.0f;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    //return [indexPath row]*30;
}

- (void) calculateTotalAmountSpendedMoneyOfArray:(NSArray*)input {
    NSInteger summary = 0;
    for (BBSHistoryItem *iterator in input) {
        summary += [iterator.summaryPrice integerValue];
    }

    self.summaryPriceLabel.text = [NSString stringWithFormat:LOC(@"shoppingCargViewController.summaryPrice"),summary];
}
@end







