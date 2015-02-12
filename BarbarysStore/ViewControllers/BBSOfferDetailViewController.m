//
//  BBSOfferDetailViewController.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/10/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferDetailViewController.h"
#import "BBSOfferDetailTopCell.h"
#import "BBSOfferDetailSizeColorCell.h"
#import "BBSOfferDetailHeaderView.h"

#import <UIImageView+WebCache.h>

@interface BBSOfferDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableDictionary *expandedInfo;
@end

@implementation BBSOfferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.expandedInfo = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2 || section == 3) {
        if ([self.expandedInfo[@(section)] boolValue]) {
            return 1;
        }
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 480;
    }
    if (indexPath.section == 1) {
        return 225;
    }
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BBSOfferDetailTopCell *cell = (BBSOfferDetailTopCell *)[tableView dequeueReusableCellWithIdentifier:@"offerDetailTopCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"BBSOfferDetailTopCell" owner:self options:nil][0];
        }
        cell.offer = self.offer;
        return cell;
    }
    if (indexPath.section == 1) {
        BBSOfferDetailSizeColorCell *cell = (BBSOfferDetailSizeColorCell *)[tableView dequeueReusableCellWithIdentifier:@"offerDetailSizeColorCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"BBSOfferDetailSizeColorCell" owner:self options:nil][0];
        }
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"defaultCell"];
    }
    cell.textLabel.text = indexPath.section == 2 ? self.offer.descriptionText : self.offer.model;
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0 || indexPath.section == 1) {
        return;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return nil;
    }
    NSString *sectionTitle;
    if (section == 2) {
        sectionTitle = @"Описание";
    } else {
        sectionTitle = @"О бренде";
    }
    BBSOfferDetailHeaderView *header = [[BBSOfferDetailHeaderView alloc] headerWithTitle:sectionTitle index:section];
    [header setTouchUpTarget:self selector:@selector(headerTap:)];
    if (self.expandedInfo[@(section)]) {
        header.expanded = [self.expandedInfo[@(section)] boolValue];
        
    } else {
        header.expanded = NO;
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2 || section == 3) {
        return 40;
    }
    return 0;
}

- (void)headerTap:(BBSOfferDetailHeaderView *)header {
    NSInteger section = header.index;
    header.expanded = !header.expanded;
    //[header setExpanded:!header.expanded];
    [self.expandedInfo setObject:@(header.expanded) forKey:@(section)];
    [self.mainTableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    if (header.expanded) {
        [self.mainTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.mainTableView endUpdates];
    
    //TODO
    // scroll to visible
    if (!header.expanded) return;
    UITableViewCell * firstRow = [self.mainTableView cellForRowAtIndexPath:indexPath];
    if ( ![[self.mainTableView visibleCells] containsObject:firstRow]) {
        [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

@end
