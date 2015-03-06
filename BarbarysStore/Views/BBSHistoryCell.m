//
//  BBSHistoryCell.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 3/5/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSHistoryCell.h"

@interface BBSHistoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *offersLabel;

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
}

@end
