//
//  BBSOfferDetailSizeItemCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/11/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferDetailSizeItemCell.h"

@interface BBSOfferDetailSizeItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedBorderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView;

@end

@implementation BBSOfferDetailSizeItemCell

- (void)awakeFromNib {
    // Initialization code
    self.typeLabel.layer.cornerRadius = self.typeLabel.frame.size.width / 2;
    self.typeLabel.textColor = [UIColor mainDarkColor];
}

- (void)updateTypeLabel:(NSString *)typeText selected:(BOOL)isSelected {
    self.typeLabel.text = typeText;
    self.typeLabel.backgroundColor = [UIColor clearColor];
    self.selectedBorderImageView.hidden = !isSelected;
}

- (void)updateTypeBackgroundColor:(NSString *)colorHex selected:(BOOL)isSelected {
    NSArray *colors = [colorHex componentsSeparatedByString:@"-"];
    self.colorImageView.backgroundColor = [UIColor colorFromHexString:colors[0]];
    self.colorImageView.layer.cornerRadius = self.colorImageView.frame.size.width / 2;
    self.colorImageView.clipsToBounds = YES;
    self.selectedBorderImageView.hidden = !isSelected;
}

@end
