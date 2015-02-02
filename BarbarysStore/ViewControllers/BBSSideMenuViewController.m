//
//  BBSSideMenuViewController.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSSideMenuViewController.h"
#import "BBSSideMenuCell.h"

@interface BBSSideMenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@end

@implementation BBSSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizeUI];
}

#pragma mark - Customize

- (void)customizeUI {
    [self.categoryTableView setBackgroundColor:[UIColor sideMenuBackground]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (BBSSideMenuCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBSSideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sideMenuCell"];
    if (!cell) {
        cell = [[BBSSideMenuCell alloc] init];
    }
    cell.categoryTitleLabel.text = @"test";
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
