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
@property (weak, nonatomic) IBOutlet UIImageView *categoryIconImageView;

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
    self.categoryIconImageView.image = [self iconForCategory:self.index];
}

- (BBSSideMenuHeaderView *)headerWithTitle:(NSString *)title index:(NSInteger)index {
    BBSSideMenuHeaderView *header = [[NSBundle mainBundle] loadNibNamed:@"BBSSideMenuHeaderView" owner:self options:nil][0];
    header.titleLabel.text = title;
    header.index = index;
    header.categoryIconImageView.image = [self iconForCategory:index];
    return header;
}

- (UIImage *)iconForCategory:(NSInteger)index {
    UIImage *iconImage;
    switch (index) {
        case 0:
            iconImage = self.expanded ? [UIImage imageNamed:@"clothCategoryIconActive"] : [UIImage imageNamed:@"clothCategoryIcon"];
            break;
        case 1:
            iconImage = self.expanded ? [UIImage imageNamed:@"shoesCategoryIconActive"] : [UIImage imageNamed:@"shoesCategoryIcon"];
            break;
        case 2:
            iconImage = self.expanded ? [UIImage imageNamed:@"accessoriesCategoryIconActive"] : [UIImage imageNamed:@"accessoriesCategoryIcon"];
            break;
    }
    return iconImage;
}

@end
