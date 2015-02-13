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
#import "BBSCategoriesManager.h"
#import "BBSSideMenuHeaderView.h"

#import <SWRevealViewController.h>

@interface BBSSideMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categoriesSegmentedControl;

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) BBSCategorySet *subcategories;
@property (nonatomic, strong) NSMutableDictionary *expandedInfo;

- (IBAction)categoryChanged:(id)sender;

@end

@implementation BBSSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizeUI];
    //self.categories = [[[XLNDatabaseManager alloc] init] getAllCategories];
    self.categories = [BBSCategoriesManager loadCategories];
    self.subcategories = self.categories[self.categoriesSegmentedControl.selectedSegmentIndex];
    self.expandedInfo = [[NSMutableDictionary alloc] init];
    [self.categoryTableView setTableFooterView:[[UIView alloc] init]];
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

#pragma mark - IBActions

- (void)headerTap:(BBSSideMenuHeaderView *)header {
    NSInteger section = header.index;
    header.expanded = !header.expanded;
    //[header setExpanded:!header.expanded];
    [self.expandedInfo setObject:@(header.expanded) forKey:@(section)];
    [self.categoryTableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    if (header.expanded) {
        [self.categoryTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.categoryTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.categoryTableView endUpdates];
    
    //TODO
    // scroll to visible
    if (!header.expanded) return;
    UITableViewCell * firstRow = [self.categoryTableView cellForRowAtIndexPath:indexPath];
    if ( ![[self.categoryTableView visibleCells] containsObject:firstRow]) {
        [self.categoryTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.expandedInfo[@(section)] boolValue]) {
        BBSCategorySet *category = self.categories[self.categoriesSegmentedControl.selectedSegmentIndex];
        NSInteger count = [category.subcategories count];
        return count;
    }
    return 0;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [((BBSCategorySet *)self.categories[self.categoriesSegmentedControl.selectedSegmentIndex]).subcategories count];
    return count;
}

- (BBSSideMenuCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBSSideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sideMenuCell"];
    if (!cell) {
        cell = [[BBSSideMenuCell alloc] init];
    }
    BBSCategory *category = ((BBSCategorySet *)self.subcategories.subcategories[indexPath.section]).subcategories[indexPath.row];
    [cell setCategory:category];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BBSCategorySet *subcategory = self.subcategories.subcategories[section];
    BBSSideMenuHeaderView *header = [[BBSSideMenuHeaderView alloc] headerWithTitle:subcategory.name index:section];
    [header setTouchUpTarget:self selector:@selector(headerTap:)];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BBSSideMenuCell *cell = (BBSSideMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateOffers" object:nil userInfo:@{@"categoryId" : [cell categoryId]}];
    [self.revealViewController revealToggleAnimated:YES];
}

- (IBAction)categoryChanged:(id)sender {
    [self.expandedInfo removeAllObjects];
    self.subcategories = self.categories[self.categoriesSegmentedControl.selectedSegmentIndex];
    [self.categoryTableView reloadData];
}

@end
