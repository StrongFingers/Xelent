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
@property (weak, nonatomic) IBOutlet UIImageView *secondColorImageView;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@end

@implementation BBSOfferDetailSizeItemCell

- (void)awakeFromNib {
    // Initialization code
    self.typeLabel.layer.cornerRadius = self.typeLabel.frame.size.width / 2;
    self.typeLabel.textColor = [UIColor mainDarkColor];
    self.colorView.layer.cornerRadius = self.colorView.frame.size.width / 2;
    self.colorView.clipsToBounds = YES;
}

- (void)updateTypeLabel:(NSString *)typeText selected:(BOOL)isSelected {
    self.typeLabel.text = [typeText isEqualToString:LOC(@"offerDetail.sizeAbsent")] ? @"∞" : typeText;
    self.typeLabel.backgroundColor = [UIColor clearColor];
    self.selectedBorderImageView.hidden = !isSelected;
}

- (void)updateTypeBackgroundColor:(NSString *)colorHex selected:(BOOL)isSelected {
    NSArray *colors = [colorHex componentsSeparatedByString:@"-"];
    if ([colors count] == 1) {
        self.colorImageView.backgroundColor = [UIColor colorFromHexString:colors[0]];
        self.secondColorImageView.hidden = YES;
    } else {
        self.colorImageView.backgroundColor = [UIColor colorFromHexString:colors[0]];
        self.secondColorImageView.backgroundColor = [UIColor colorFromHexString:colors[1]];
        self.secondColorImageView.hidden = NO;
    }
    self.selectedBorderImageView.hidden = !isSelected;
}

@end
