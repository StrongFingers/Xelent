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

@end

@implementation BBSOfferDetailSizeItemCell

- (void)awakeFromNib {
    // Initialization code
    self.typeLabel.layer.cornerRadius = self.typeLabel.frame.size.width / 2;
    self.typeLabel.textColor = [UIColor mainDarkColor];
}

- (void)updateTypeLabel:(NSString *)typeText {
    self.typeLabel.text = typeText;
    self.typeLabel.backgroundColor = [UIColor clearColor];
}

- (void)updateTypeBackgroundColor:(NSString *)colorHex {
    self.typeLabel.backgroundColor = [UIColor colorFromHexString:colorHex];
    self.typeLabel.text = @"";
}

@end
