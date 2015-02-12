//
//  BBSOfferDetailHeaderView.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/12/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferDetailHeaderView.h"

@interface BBSOfferDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BBSOfferDetailHeaderView

- (void)awakeFromNib {
    
}

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    if (expanded) {
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.95 alpha:1];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
    
}

- (BBSOfferDetailHeaderView *)headerWithTitle:(NSString *)title index:(NSInteger)index {
    BBSOfferDetailHeaderView *header = [[NSBundle mainBundle] loadNibNamed:@"BBSOfferDetailHeaderView" owner:self options:nil][0];
    header.titleLabel.text = title;
    header.index = index;
    return header;
}

@end
