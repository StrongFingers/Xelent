//
//  BBSProfileEditViewController.m
//  BarbarysStore
//
//  Created by Admin on 01.03.15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSProfileEditViewController.h"

@interface BBSProfileEditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)saveButtonPressed:(id)sender;
@end

@implementation BBSProfileEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self customizeUI];
}

- (void)customizeUI {
	self.navigationItem.title = LOC(@"profileEditViewController.title");
	self.infoLabel.text = LOC(@"profileEditViewController.infoTitle");
	self.nameLabel.text = LOC(@"profileEditViewController.name.title");
	self.phoneLabel.text = LOC(@"profileEditViewController.phone.title");
	self.emailLabel.text = LOC(@"profileEditViewController.email.title");
	[self.saveButton setTitle:LOC(@"profileEditViewController.saveButton.title") forState:UIControlStateNormal];
	self.saveButton.layer.cornerRadius = 2.0;
	self.saveButton.layer.masksToBounds = YES;
}

- (IBAction)saveButtonPressed:(id)sender {
}

@end
