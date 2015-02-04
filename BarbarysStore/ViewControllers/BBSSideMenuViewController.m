//
//  BBSSideMenuViewController.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSSideMenuViewController.h"
#import "BBSSideMenuCell.h"
#import "XLNDatabaseManager.h"

#import <SWRevealViewController.h>

@interface BBSSideMenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@property (nonatomic, strong) NSArray *categories;

@end

@implementation BBSSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizeUI];
    self.categories = [[[XLNDatabaseManager alloc] init] getAllCategories];
}

#pragma mark - Customize

- (void)customizeUI {
    [self.view setBackgroundColor:[UIColor sideMenuBackground]];
    [self.categoryTableView setBackgroundColor:[UIColor sideMenuBackground]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categories count];
}

- (BBSSideMenuCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBSSideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sideMenuCell"];
    if (!cell) {
        cell = [[BBSSideMenuCell alloc] init];
    }
    [cell setCategory:self.categories[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BBSSideMenuCell *cell = (BBSSideMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateOffers" object:nil userInfo:@{@"categoryId" : [cell categoryId]}];
    [self.revealViewController revealToggleAnimated:YES];
}


@end
