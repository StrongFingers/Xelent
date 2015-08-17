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
@property (nonatomic, strong) BBSSideMenuHeaderView *expandedHeader;

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
    [self.categoryTableView setTableFooterView:[[UIView alloc] init]];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"categorySelected" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateOffers" object:nil userInfo:@{@"categoryId" : note.userInfo[@"categoryId"], @"gender" : @(self.categoriesSegmentedControl.selectedSegmentIndex)}];
    }];
}

#pragma mark - Customize

- (void)customizeUI {
    [self.view setBackgroundColor:[UIColor sideMenuCategorySeparator]];
    [self.categoryTableView setBackgroundColor:[UIColor sideMenuBackground]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void)hideSection:(BBSSideMenuHeaderView *)header {
    NSInteger section = header.index;
    header.expanded = !header.expanded;
    [self.categoryTableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    [self.categoryTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.categoryTableView endUpdates];
}

#pragma mark - IBActions

- (void)headerTap:(BBSSideMenuHeaderView *)header {
    if (self.expandedHeader && ![self.expandedHeader isEqual:header]) {
        [self hideSection:self.expandedHeader];
    }
    self.expandedHeader = header;
    NSInteger section = header.index;
    header.expanded = !header.expanded;
    [self.categoryTableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    if (header.expanded) {
        [self.categoryTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.categoryTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.expandedHeader = nil;
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
    if (self.expandedHeader.expanded && self.expandedHeader.index == section) {
        return 1;
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
    BBSCategorySet *category = ((BBSCategorySet *)self.subcategories.subcategories[indexPath.section]);
    [cell updateCategory:category];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BBSCategorySet *subcategory = self.subcategories.subcategories[section];
    BBSSideMenuHeaderView *header = [[BBSSideMenuHeaderView alloc] headerWithTitle:subcategory.name index:section gender:self.categoriesSegmentedControl.selectedSegmentIndex];
    [header setTouchUpTarget:self selector:@selector(headerTap:)];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger maxHeight = self.categoryTableView.frame.size.height - 130;
    NSInteger rowHeight = [((BBSCategorySet *)self.subcategories.subcategories[indexPath.section]).subcategories count] * 25;
    return MIN(maxHeight, rowHeight + 15);
}

#pragma mark - UITableViewDelegate

- (IBAction)categoryChanged:(id)sender {
    self.expandedHeader = nil;
    self.subcategories = self.categories[self.categoriesSegmentedControl.selectedSegmentIndex];
    [self.categoryTableView reloadData];
}

@end
