//
//  BBSSideMenuCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSSideMenuCell.h"

@interface BBSSideMenuCell ()

@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;
@property (nonatomic, strong, getter=categoryId) NSString *categoryId;

@end

@implementation BBSSideMenuCell

- (void)setCategory:(NSDictionary *)categoryInfo {
    self.categoryTitleLabel.text = categoryInfo[@"name"];
    self.categoryId = categoryInfo[@"id"];
}


@end
