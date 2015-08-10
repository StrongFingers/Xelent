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
    self.colorView.layer.cornerRadius = self.colorView.frame.size.width / 2;


    /*self.selectedBorderImageView.backgroundColor = [UIColor grayColor];
    self.selectedBorderImageView.layer.cornerRadius = self.colorView.frame.size.width / 2;
    self.selectedBorderImageView.clipsToBounds = YES;
    self.selectedBorderImageView.hidden = NO;*/
   
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
}/*
- (void)updateTypeLabel:(NSString *)typeText selected:(BOOL)isSelected enabled:(BOOL)isEnabled {
    self.typeLabel.text = [typeText isEqualToString:LOC(@"offerDetail.sizeAbsent")] ? @"∞" : typeText;
    self.typeLabel.backgroundColor = [UIColor mainDarkColor];
    if (isEnabled) {
        self.typeLabel.textColor = [UIColor mainDarkColor];
    } else {
        self.typeLabel.textColor = [UIColor customDarkGrayColor];
    }
    self.selectedBorderImageView.hidden = !isSelected;
}*/

- (void)updateTypeBackgroundColor:(NSString *)colorHex selected:(BOOL)isSelected {
    NSArray *colors = [colorHex componentsSeparatedByString:@"-"];
    if ([colors count] == 1) {
        self.colorImageView.backgroundColor = [UIColor colorFromHexString:colors[0]];
        self.secondColorImageView.hidden = YES;

    } else {

        
        self.colorImageView.backgroundColor = [UIColor grayColor];
        //self.colorImageView.backgroundColor = [UIColor colorFromHexString:colors[0]];
        //self.secondColorImageView.backgroundColor = [UIColor colorFromHexString:colors[1]];
        self.secondColorImageView.backgroundColor = [UIColor redColor];
        self.secondColorImageView.hidden = NO;
    }
    
    self.selectedBorderImageView.hidden = NO;
    /*if (isSelected) {
        self.selectedBorderImageView.backgroundColor = [UIColor mainDarkColor];
    } else {
        
        //self.colorView.layer.backgroundColor = [UIColor redColor];
            //self.selectedBorderImageView.backgroundColor = [UIColor redColor];
         self.selectedBorderImageView.backgroundColor = [UIColor mainDarkColor];
            }*/

    self.selectedBorderImageView.hidden = !isSelected;
    
    

}

@end


/*        self.colorImageView.backgroundColor = [UIColor colorFromHexString:colors[0]];
 self.selectedBorderImageView.backgroundColor = [UIColor grayColor];
 self.selectedBorderImageView.layer.cornerRadius = self.colorView.frame.size.width / 2;
 self.selectedBorderImageView.clipsToBounds = YES;
 self.selectedBorderImageView.hidden = NO;*/