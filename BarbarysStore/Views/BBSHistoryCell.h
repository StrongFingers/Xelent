//
//  BBSHistoryCell.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 3/5/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSHistoryItem.h"

@interface BBSHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *offersLabel;
@property (nonatomic,strong) NSString *offersInCart;


- (void)updateCellInfo:(BBSHistoryItem *)dataInfo;
- (void)fontSizeToHistoryCell:(float)value item:(BBSHistoryItem *)inputItem;
@end
