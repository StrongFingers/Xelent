//
//  BBSProfileViewController.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/9/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSProfileViewController.h"

@interface BBSProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonPressed:(id)sender;
@end

@implementation BBSProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self customizeUI];
}

- (void)customizeUI {
	self.navigationItem.title = LOC(@"profileViewController.title");
	self.infoLabel.text = LOC(@"profileViewController.info");
	self.inputLabel.text = LOC(@"profileViewController.inputTitle");
	self.nameTextField.placeholder = LOC(@"profileViewController.name.placeholder");
	self.phoneTextField.placeholder = LOC(@"profileViewController.phone.placeholder");
	self.emailTextField.placeholder = LOC(@"profileViewController.email.placeholder");
	[self.loginButton setTitle:LOC(@"profileViewController.loginButton.title") forState:UIControlStateNormal];
	self.loginButton.layer.cornerRadius = 2.0;
	self.loginButton.layer.masksToBounds = YES;
}

- (IBAction)loginButtonPressed:(id)sender {
	[self performSegueWithIdentifier:@"toDiscount" sender:self];
}
@end
