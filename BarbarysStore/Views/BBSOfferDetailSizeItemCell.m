//
//  BBSOfferDetailSizeItemCell.m
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 8/26/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSOfferDetailSizeItemCell.h"



@interface BBSOfferDetailSizeItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedBorderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *GrayBorderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *colorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondColorImageView;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@end

@implementation BBSOfferDetailSizeItemCell


- (void)awakeFromNib {
    // Initialization code
    self.typeLabel.layer.cornerRadius = self.typeLabel.frame.size.width / 2;
    self.colorView.layer.cornerRadius = self.colorView.frame.size.width / 2;
    self.colorView.clipsToBounds = YES;
    
    
}

- (void)updateTypeLabel:(NSString *)typeText selected:(BOOL)isSelected enabled:(BOOL)isEnabled {
    self.typeLabel.text = [typeText isEqualToString:LOC(@"offerDetail.sizeAbsent")] ? @"∞" : typeText;
    self.typeLabel.backgroundColor = [UIColor clearColor];

    if (isEnabled) {
     self.typeLabel.textColor = [UIColor mainDarkColor];
     } else {
     self.typeLabel.textColor = [UIColor customDarkGrayColor];
     }

    self.selectedBorderImageView.hidden = !isSelected;

}

- (void)updateTypeBackgroundColor:(NSString *)colorHex selected:(BOOL)isSelected {
    NSArray *colors = [colorHex componentsSeparatedByString:@"-"];
    if ([colors count] == 1) {
        self.colorImageView.backgroundColor = [UIColor colorFromHexString:colors[0]];
        self.secondColorImageView.hidden = YES;

    } else {


        self.colorImageView.backgroundColor = [UIColor colorFromHexString:colors[0]];//colorHex:colors[0]];
        self.secondColorImageView.backgroundColor = [UIColor colorFromHexString:colors[1]];
        self.secondColorImageView.hidden = NO;
        if ([colors[0] isEqualToString:@"ffffff"] || [colors[1] isEqualToString :@"ffffff"]) {
            self.selectedBorderImageView.hidden = !isSelected;
            self.GrayBorderImageView.hidden = isSelected;
        }
    }

    self.selectedBorderImageView.hidden = !isSelected;
    if ([colorHex isEqualToString:@"ffffff"]) {
        self.GrayBorderImageView.hidden = isSelected;
    }

}

@end