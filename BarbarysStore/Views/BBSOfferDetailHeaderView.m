//
//  BBSOfferDetailHeaderView.m
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 8/26/15.
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
        self.titleLabel.textColor = [UIColor priceColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor customDarkGrayColor];
    }
    
}

- (BBSOfferDetailHeaderView *)headerWithTitle:(NSString *)title index:(NSInteger)index {
    BBSOfferDetailHeaderView *header = [[NSBundle mainBundle] loadNibNamed:@"BBSOfferDetailHeaderView" owner:self options:nil][0];
    header.titleLabel.text = title;
    header.index = index;
    return header;
}

@end
