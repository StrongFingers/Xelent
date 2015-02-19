//
//  BBSSideMenuHeaderView.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/13/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSSideMenuHeaderView.h"

@interface BBSSideMenuHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BBSSideMenuHeaderView

- (void)awakeFromNib {
    
}

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    if (expanded) {
        self.titleLabel.textColor = [UIColor sideMenuExpandedHeaderTitle];
    } else {
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (BBSSideMenuHeaderView *)headerWithTitle:(NSString *)title index:(NSInteger)index {
    BBSSideMenuHeaderView *header = [[NSBundle mainBundle] loadNibNamed:@"BBSSideMenuHeaderView" owner:self options:nil][0];
    header.titleLabel.text = title;
    header.index = index;
    return header;
}

@end
