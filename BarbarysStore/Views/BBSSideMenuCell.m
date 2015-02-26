//
//  BBSSideMenuCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSSideMenuCell.h"
#import "BBSCategory.h"

@interface BBSSideMenuCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;
@property (nonatomic, strong, getter=categoryId) NSString *categoryId;
@property (weak, nonatomic) IBOutlet UITableView *subcategoriesTableView;
@property (nonatomic, strong) BBSCategorySet *category;
@end

@implementation BBSSideMenuCell

- (void)awakeFromNib {
    self.subcategoriesTableView.delegate = self;
    self.subcategoriesTableView.dataSource = self;
    self.backgroundColor = [UIColor sideMenuSubBackground];
    self.subcategoriesTableView.separatorColor = [UIColor sideMenuSubcategorySeparator];
}

- (void)updateCategory:(BBSCategorySet *)categoryInfo {
    self.category = categoryInfo;
    [self.subcategoriesTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.category.subcategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"defaultCell"];
    }
    BBSCategory *subcategory = self.category.subcategories[indexPath.row];
    cell.textLabel.text = subcategory.name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *categoryId = ((BBSCategory *)self.category.subcategories[indexPath.row]).categoryId;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"categorySelected" object:nil userInfo:@{@"categoryId" : categoryId}];
}


@end
