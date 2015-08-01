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
#import "BBSPhotoPagingViewController.h"
#import "XLNCommonMethods.h"
#import "XLNDatabaseManager.h"
#import "BBSOfferManager.h"

#import "BBSAPIRequest.h"
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>

@interface BBSOfferDetailViewController () <UITableViewDataSource, UITableViewDelegate, offerDetailTopCellDelegate, BBSAPIRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableDictionary *expandedInfo;
@property (nonatomic, strong) BBSOffer *offer;
@property (nonatomic, strong) BBSAPIRequest *offerRequest;
@property (nonatomic, strong) id shoppingCartNotification;
@property (nonatomic, strong) id updateSizeColorNotification;
@property (nonatomic, strong) NSString *selectedSize;
@property (nonatomic, strong) NSMutableAttributedString *tmpMutableString;
@end

@implementation BBSOfferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.expandedInfo = [[NSMutableDictionary alloc] init];
    if (!self.brandName)
    {
        self.navigationItem.title = self.offer.brand;
    } else
        {
        self.navigationItem.title = self.brandName;
        };
    
    
    if (self.fromShoppingCart) {
        XLNDatabaseManager *manager = [[XLNDatabaseManager alloc] init];
        self.offer = [manager cartOfferById:self.offerId];
        self.selectedColor = self.offer.color;
    } else {
        self.offerRequest = [[BBSAPIRequest alloc] initWithDelegate:self];
        [self.offerRequest getOfferById:self.offerId];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.shoppingCartNotification = [[NSNotificationCenter defaultCenter] addObserverForName:@"addToShoppingCart" object:nil queue:nil usingBlock:^(NSNotification *note) {
        XLNDatabaseManager *dbManager = [[XLNDatabaseManager alloc] init];
       
        BBSCartOffer *cartOffer = [[BBSCartOffer alloc] initWithOffer:self.offer];
        NSString *colorId = note.userInfo[@"color"];
        cartOffer.choosedColor = self.offer.colorsType[colorId][0][@"color_name"];
        cartOffer.size = note.userInfo[@"size"];
        cartOffer.quantity = @"1";
        [dbManager addToShoppingCart:cartOffer];
    }];
    
    self.updateSizeColorNotification = [[NSNotificationCenter defaultCenter] addObserverForName:@"updateSizeColorSection" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary *userInfo = note.userInfo;
        if (userInfo[@"selectedSize"]) {
            self.selectedSize = userInfo[@"selectedSize"];
            [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        if (userInfo[@"selectedColor"]) {
            self.selectedColor = userInfo[@"selectedColor"];
            self.offer.color = self.selectedColor;
            [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self.shoppingCartNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self.updateSizeColorNotification];
    [super viewWillDisappear:animated];
}

#pragma mark - Methods

- (void)updateOffer:(BBSOffer *)offer {
    _offer = offer;
    self.selectedColor = offer.color;
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    if ([self.expandedInfo[@(section)] boolValue]) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 430;
            break;
        case 1:
            return 225;
            break;
        case 2:
          /*  return [XLNCommonMethods findHeightForText:[self.offer.descriptionText stringByAppendingString:@""] havingWidth:320 andFont:[UIFont lightFont:18]].height;*/
        
            return ceilf([XLNCommonMethods findHeightForMutableAttributedText:self.tmpMutableString havingWidth:320].height);
            break;
        case 3:
           // return [XLNCommonMethods findHeightForText:[self.offer.descriptionText string] havingWidth:320 andFont:[UIFont lightFont:16]].height;
            return ceilf([XLNCommonMethods findHeightForText:[self.offer.brandAboutDescription stringByAppendingString:@""] havingWidth:320 andFont:[UIFont lightFont:16]].height);
            //return 100;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BBSOfferDetailTopCell *cell = (BBSOfferDetailTopCell *)[tableView dequeueReusableCellWithIdentifier:@"offerDetailTopCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"BBSOfferDetailTopCell" owner:self options:nil][0];
        }
        cell.offer = self.offer;
        [cell updateElements];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        BBSOfferDetailSizeColorCell *cell = (BBSOfferDetailSizeColorCell *)[tableView dequeueReusableCellWithIdentifier:@"offerDetailSizeColorCell"];
        
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"BBSOfferDetailSizeColorCell" owner:self options:nil][0];
        }
        if (self.offer) {
            if (!self.selectedSize) {
                self.selectedSize = self.offer.colorsType[self.selectedColor][0][@"size_name"];
            }
            NSMutableArray *sizes = [NSMutableArray array];
            for (NSDictionary *item in self.offer.colorsType[self.selectedColor]) {
                [sizes addObject:item[@"size_name"]];
            }
            cell.defaultSizes = [self.offer.sizesType allKeys];
            [cell updateSizes:sizes selectedSize:self.selectedSize];
            NSMutableDictionary *colors = [NSMutableDictionary dictionary];
            for (NSDictionary *item in self.offer.sizesType[self.selectedSize]) {
                [colors setObject:item[@"color_hex"] forKey:item[@"color_id"]];
            }
            [cell updateColors:colors selectedColor:self.selectedColor];
        }
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"defaultCell"];
    }
    cell.textLabel.font = [UIFont lightFont:15];
    //Next switch load an text to expanding cells of detail offer card
   
    switch (indexPath.section) {
        case 2:
            
            self.tmpMutableString = [[NSMutableAttributedString alloc] initWithString:self.offer.descriptionText];
            cell.textLabel.font = [UIFont lightFont:17];
            self.tmpMutableString = [XLNCommonMethods convertToBoldedString:self.offer.descriptionText];
            [cell.textLabel setAttributedText:self.tmpMutableString];
            break;
        case 3:
            
            self.tmpMutableString = [[NSMutableAttributedString alloc] initWithString:@""];
            self.tmpMutableString = [[NSMutableAttributedString alloc] initWithString:self.offer.brandAboutDescription];
            self.tmpMutableString = [XLNCommonMethods convertToBoldedString:self.offer.brandAboutDescription];
            [cell.textLabel setAttributedText:self.tmpMutableString];
            break;
    }
    cell.textLabel.numberOfLines = 0;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor detailCellBackgroundColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return nil;
    }
    NSString *sectionTitle;
    if (section == 2) {
        sectionTitle = LOC(@"offerDetail.descriptionSection.headerTitle");
    } else if (section == 3) {
        sectionTitle = LOC(@"offerDetail.brandSection.headerTitle");
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
    if (section == 0 || section == 1) {
        return 0;
    }
    return 40;
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
    if (!header.expanded) {return;}
    else {
            UITableViewCell * firstRow = [self.mainTableView cellForRowAtIndexPath:indexPath];
            if ( [[self.mainTableView visibleCells] containsObject:firstRow]) {
                CGPoint expandedHeaderLeftTopPoint = [self.mainTableView contentOffset];
                CGRect screenRect = [[UIScreen mainScreen] bounds];
             
                expandedHeaderLeftTopPoint.y +=screenRect.size.height / 2;
                [self.mainTableView scrollsToTop];
                [self.mainTableView setContentOffset:expandedHeaderLeftTopPoint animated:YES];
                [self.mainTableView reloadData];
                //[self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    }
}

#pragma mark - OfferDetailTopCellDelegate

- (void)imageTapped:(NSInteger)imageIndex {
    if ([self.offer.pictures count] > 0) {
        BBSPhotoPagingViewController *ctrl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BBSPhotoPagingViewController"];
        ctrl.photos = self.offer.pictures[self.selectedColor];
        ctrl.currentIndex = imageIndex;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma mark - BBSAPIRequest deletage

- (void)requestFinished:(id)responseObject sender:(id)sender {
    DLog(@"\n zzi_%@", responseObject);
    if (!self.fromFavorites) {
        self.offer = nil;
        self.offer = [BBSOfferManager parseDetailOffer:responseObject[0]];
        self.offer.offerId = self.offerId;
        self.offer.color = self.selectedColor;
        self.offer.thumbnailUrl = self.offer.pictures[self.selectedColor][0];
        [self.mainTableView reloadData];
        BBSOfferManager *manager = [[BBSOfferManager alloc] init];
        if ([manager countOfRows:self.offer] > 0) {
            [manager updateOfferInFavorites:self.offer state:offerUpdate];
        }
    }
    

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)requestFinishedWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


@end
