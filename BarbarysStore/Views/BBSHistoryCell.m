//
//  BBSHistoryCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 3/5/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSHistoryCell.h"
#import "BBSOffer.h"

@interface BBSHistoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePercentLabel;


@end

@implementation BBSHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellInfo:(BBSHistoryItem *)dataInfo {
    self.dateLabel.text = dataInfo.createDate;
    self.priceLabel.text = dataInfo.summaryPrice;
    self.salePercentLabel.text = dataInfo.saleValue;
    
    
    self.offersLabel.text = [self offerLabelTextMake:dataInfo.offers];
    [self fontSizeToHistoryCell:12.0 item:dataInfo];
}

- (void)fontSizeToHistoryCell:(float)value item:(BBSHistoryItem *)inputItem{
    UIFont *ownFont  = [UIFont systemFontOfSize:value];
    UIFont *ownFont2 = [UIFont systemFontOfSize:value-3.0];
    
    [self.dateLabel setFont:ownFont];
    [self.priceLabel setFont:ownFont];
    [self.salePercentLabel setFont:ownFont];

    [self.offersLabel setFont:ownFont2];
    self.offersLabel.adjustsFontSizeToFitWidth =YES;
    [self.offersLabel sizeToFit];
   /* CGSize size = [self.offersLabel.text sizeWithAttributes:@{NSFontAttributeName:ownFont2}];
    
    self.offersLabel.frame =CGRectMake(self.offersLabel.frame.origin.x, self.offersLabel.frame.origin.y, size.width, size.height);*/
}

- (NSString *)offerLabelTextMake :(NSArray*)input{
    NSMutableString *temp = [[NSMutableString alloc] initWithString:@""];
    for (BBSOffer *iterator in input) {
        [temp appendString:[NSString stringWithFormat:@"%@",iterator.model]];
        if ([input count] != 1) {
            [temp appendString:@"\n"];
        }
    }
    NSString *result =[[NSString alloc] initWithString:[temp substringWithRange:NSMakeRange(0, [temp length])]];
    self.offersInCart = result;
    return result;
}

@end
