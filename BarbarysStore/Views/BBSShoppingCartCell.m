//
//  BBSShoppingCartCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/20/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSShoppingCartCell.h"

#import "UIImageView+WebCache.h"

@interface BBSShoppingCartCell ()

@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UILabel *offerBrandLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation BBSShoppingCartCell

- (void)awakeFromNib {
    // Initialization code
    self.offerBrandLabel.textColor = [UIColor mainDarkColor];
    self.priceLabel.textColor = [UIColor priceColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOffer:(BBSCartOffer *)offer {
    NSURL *imageUrl = [NSURL URLWithString:offer.thumbnailUrl];
    [self.offerImageView sd_setImageWithURL:imageUrl];
    self.offerBrandLabel.text = offer.vendor;
    self.offerTypeLabel.text = offer.model;
    self.sizeLabel.attributedText = [self setBoldSubstring:[NSString stringWithFormat:LOC(@"shoppingCartCell.size"), offer.size]];
    self.colorLabel.attributedText = [self setBoldSubstring:[NSString stringWithFormat:LOC(@"shoppingCartCell.color"), offer.choosedColor]];
    self.quantityLabel.attributedText = [self setBoldSubstring:[NSString stringWithFormat:LOC(@"shoppingCartCell.quantity"), offer.quantity]];
    self.priceLabel.text = offer.price;
}

- (NSAttributedString *)setBoldSubstring:(NSString *)outputString {
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:outputString];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@":" options:kNilOptions error:nil];
    
    NSRange range = NSMakeRange(0, outputString.length);
    
    [regex enumerateMatchesInString:outputString options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSInteger length = [outputString length] - [result rangeAtIndex:0].location - 1;
        NSRange subStringRange = NSMakeRange([result rangeAtIndex:0].location + 1, length);
        [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:subStringRange];
    }];
    return mutableAttributedString;
}

@end
