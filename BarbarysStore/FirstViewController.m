//
//  FirstViewController.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "FirstViewController.h"
#import "XLNParser.h"

@interface FirstViewController ()

@property (nonatomic, strong) NSDate *startDate;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserverForName:@"parsingStarted" object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.startDate = [NSDate date];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"parsingEnded" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDate *endDate = [NSDate date];
        CGFloat difference = [endDate timeIntervalSinceDate:self.startDate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%f", difference] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        });
    }];
    NSURL *url = [NSURL URLWithString:@"http://barbarys.com/aggregator/aggregatorall/yml.xml"];
    [[XLNParser alloc] ininWithURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
