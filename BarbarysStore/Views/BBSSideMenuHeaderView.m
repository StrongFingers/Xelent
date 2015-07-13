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

@property (nonatomic) NSInteger genderIndex;

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
    self.categoryIconImageView.image = [self iconForCategory:self.index genderIndex:self.genderIndex];
}

- (BBSSideMenuHeaderView *)headerWithTitle:(NSString *)title index:(NSInteger)index gender:(NSInteger)genderIndex {
    BBSSideMenuHeaderView *header = [[NSBundle mainBundle] loadNibNamed:@"BBSSideMenuHeaderView" owner:self options:nil][0];
    header.titleLabel.text = title;
    header.index = index;
    header.genderIndex = genderIndex;
    header.categoryIconImageView.image = [self iconForCategory:index genderIndex:genderIndex];
    return header;
}

- (UIImage *)iconForCategory:(NSInteger)index genderIndex:(NSInteger)genderIndex {
    UIImage *iconImage;
    switch (genderIndex) {
        case 0:
            switch (index) {
                case 0:
                    iconImage = self.expanded ? [UIImage imageNamed:@"womenClothCategoryIconActive"] : [UIImage imageNamed:@"womenClothCategoryIcon"];
                    break;
                case 1:
                    iconImage = self.expanded ? [UIImage imageNamed:@"womenShoesCategoryIconActive"] : [UIImage imageNamed:@"womenShoesCategoryIcon"];
                    break;
                case 2:
                    iconImage = self.expanded ? [UIImage imageNamed:@"womenAccessoriesCategoryIconActive"] : [UIImage imageNamed:@"womenAccessoriesCategoryIcon"];
                    break;
            }
            break;
        case 1:
            switch (index) {
                case 0:
                    iconImage = self.expanded ? [UIImage imageNamed:@"menClothCategoryIconActive"] : [UIImage imageNamed:@"menClothCategoryIcon"];
                    break;
                case 1:
                    iconImage = self.expanded ? [UIImage imageNamed:@"menShoesCategoryIconActive"] : [UIImage imageNamed:@"menShoesCategoryIcon"];
                    break;
                case 2:
                    iconImage = self.expanded ? [UIImage imageNamed:@"menAccessoriesCategoryIconActive"] : [UIImage imageNamed:@"menAccessoriesCategoryIcon"];
                    break;
            }
            break;
        case 2:
            switch (index) {
                case 0:
                    iconImage = self.expanded ? [UIImage imageNamed:@"childrenClothCategoryIconActive"] : [UIImage imageNamed:@"childrenClothCategoryIcon"];
                    break;
                case 1:
                    iconImage = self.expanded ? [UIImage imageNamed:@"childrenShoesCategoryIconActive"] : [UIImage imageNamed:@"childrenShoesCategoryIcon"];
                    break;
                case 2:
                    iconImage = self.expanded ? [UIImage imageNamed:@"childrenAccessoriesCategoryIconActive"] : [UIImage imageNamed:@"childrenAccessoriesCategoryIcon"];
                    break;
            }
            break;
            break;

    }
    return iconImage;
}

@end
