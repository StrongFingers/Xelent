//
//  BBSDiscountDetailsViewController.m
//  BarbarysStore
//
//  Created by Admin on 01.03.15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSDiscountDetailsViewController.h"

@interface BBSDiscountDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *discountScrollView;

@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UILabel *discountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountValueTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountCommentLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@end

@implementation BBSDiscountDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self configureUI];
}

- (void)configureUI {
	self.navigationItem.title = LOC(@"discountViewController.title");
	
	self.discountNameLabel.text = LOC(@"discountViewController.discount");
	self.discountTitleLabel.text = LOC(@"discountViewController.discountShare.title");
	self.discountCommentLabel.text = LOC(@"discountViewController.discountShare.comment");
	self.discountValueLabel.text = [NSString stringWithFormat:LOC(@"discountViewController.discountValue"), 3];
	self.discountValueTitleLabel.text = LOC(@"discountViewController.discountValueTitle");
	self.discountView.layer.cornerRadius = 2.0;
	self.discountView.layer.masksToBounds = YES;

	self.infoLabel.text = LOC(@"discountDetailsViewController.infoTitle");
}

@end
