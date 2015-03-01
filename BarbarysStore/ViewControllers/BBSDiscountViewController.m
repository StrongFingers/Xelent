//
//  BBSDiscountViewController.m
//  BarbarysStore
//
//  Created by Admin on 26.02.15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSDiscountViewController.h"

@interface BBSDiscountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumValueLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *discountsScrollView;

@property (weak, nonatomic) IBOutlet UIView *shareDiscountView;
@property (weak, nonatomic) IBOutlet UILabel *shareDiscountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareDiscountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareDiscountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareDiscountValueTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareDiscountCommentLabel;

@property (weak, nonatomic) IBOutlet UIView *collectDiscountView;
@property (weak, nonatomic) IBOutlet UILabel *collectDiscountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectDiscountTitleLabel;

- (IBAction)editButtonPressed:(id)sender;
@end

@implementation BBSDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self configureUI];
	
	[self.shareDiscountView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(discountSelected:)]];
	[self.collectDiscountView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(discountSelected:)]];
}

- (void)configureUI {
	self.navigationItem.title = LOC(@"discountViewController.title");
	self.navigationItem.hidesBackButton = YES;

	self.infoLabel.text = LOC(@"discountViewController.info");
	self.infoSumLabel.text = LOC(@"discountViewController.sumInfoTitle");
	self.sumTitleLabel.text = LOC(@"discountViewController.sumValueTitle");
	self.sumValueLabel.text = [NSString stringWithFormat:LOC(@"discountViewController.sumValue"), 3];
	
	self.shareDiscountNameLabel.text = LOC(@"discountViewController.discount");
	self.shareDiscountTitleLabel.text = LOC(@"discountViewController.discountShare.title");
	self.shareDiscountCommentLabel.text = LOC(@"discountViewController.discountShare.comment");
	self.shareDiscountValueLabel.text = [NSString stringWithFormat:LOC(@"discountViewController.discountValue"), 3];
	self.shareDiscountValueTitleLabel.text = LOC(@"discountViewController.discountValueTitle");
	self.shareDiscountView.layer.cornerRadius = 2.0;
	self.shareDiscountView.layer.masksToBounds = YES;
	
	self.collectDiscountNameLabel.text = LOC(@"discountViewController.discount");
	self.collectDiscountTitleLabel.text = LOC(@"discountViewController.discountCollect.title");
	self.collectDiscountView.layer.cornerRadius = 2.0;
	self.collectDiscountView.layer.masksToBounds = YES;
}

- (void)discountSelected:(UIGestureRecognizer *)recognizer {
	[self performSegueWithIdentifier:@"toDiscountDetails" sender:self];
}

- (IBAction)editButtonPressed:(id)sender {
	[self performSegueWithIdentifier:@"toProfileEdit" sender:self];
}

@end
